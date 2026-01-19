import 'package:sqflite/sqflite.dart';
import 'package:sun_scan/core/enum/enum.dart';
import 'package:sun_scan/core/storage/database.dart';
import 'package:sun_scan/data/model/guest_activity_model.dart';
import 'package:sun_scan/data/model/guest_session_model.dart';
import 'package:uuid/uuid.dart';

import '../../model/guest_photo_model.dart';

class GuestSessionLocalDatasource {
  final DatabaseHelper _databaseHelper;

  GuestSessionLocalDatasource(this._databaseHelper);

  factory GuestSessionLocalDatasource.create() {
    final databaseHelper = DatabaseHelper();
    return GuestSessionLocalDatasource(databaseHelper);
  }

  Future<GuestSessionModel?> getActiveSession(String guestUuid) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'guest_sessions',
      where: 'guest_uuid = ? AND checkout_at IS NULL AND is_deleted = 0',
      whereArgs: [guestUuid],
      orderBy: 'checkin_at DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;
    return GuestSessionModel.fromJson(result.first);
  }

  Future<GuestSessionModel?> createSession({
    required String guestUuid,
    required String eventUuid,
  }) async {
    final db = await _databaseHelper.database;

    final now = DateTime.now().toUtc();
    final session = GuestSessionModel(
      sessionUuid: const Uuid().v4(),
      guestUuid: guestUuid,
      eventUuid: eventUuid,
      checkinAt: now,
      createdAt: now,
      syncStatus: SyncStatus.pending,
    );

    try {
      await db.insert('guest_sessions', session.toJson());
      return session;
    } catch (e) {
      throw Exception('Failed to create guest session: $e');
    }
  }

  Future<void> closeSession(String sessionUuid) async {
    final db = await _databaseHelper.database;

    final now = DateTime.now().toUtc();

    try {
      await db.update(
        'guest_sessions',
        {
          'checkout_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
          'sync_status': SyncStatus.pending.name,
        },
        where: 'session_uuid = ? AND is_deleted = 0',
        whereArgs: [sessionUuid],
      );
    } catch (e) {
      throw Exception('Failed to close guest session: $e');
    }
  }

  Future<List<GuestActivityModel>> getGuestActivities(String eventUuid) async {
    print('[GuestSessionDatasource] getGuestActivities called with eventUuid: $eventUuid');
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT 
        g.name,
        g.phone,
        gp.file_path AS photo_path,
        gp.file_url AS photo_url,
        gc.name AS category_name,
        gs.checkin_at,
        gs.checkout_at
      FROM guest_sessions gs
      INNER JOIN guests g ON gs.guest_uuid = g.guest_uuid
      LEFT JOIN guest_categories gc ON g.guest_category_uuid = gc.category_uuid
      LEFT JOIN guest_photos gp 
        ON g.guest_uuid = gp.guest_uuid 
        AND gp.is_primary = 1 
        AND gp.photo_type = '${PhotoType.identity.name}' 
        AND gp.is_deleted = 0
      WHERE gs.event_uuid = ? AND gs.is_deleted = 0
      ORDER BY gs.checkin_at DESC
    ''',
      [eventUuid],
    );

    return result.map(GuestActivityModel.fromJson).toList();
  }

  Future<List<GuestSessionModel>> getPendingSessions(int limit) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'guest_sessions',
      where: 'sync_status = ? AND is_deleted = 0',
      whereArgs: [SyncStatus.pending.name],
      orderBy: 'created_at ASC',
      limit: limit,
    );

    return result.map(GuestSessionModel.fromJson).toList();
  }

  Future<void> markSessionsAsSynced(List<String> sessionUuids) async {
    if (sessionUuids.isEmpty) return;

    final db = await _databaseHelper.database;
    final placeholders = List.filled(sessionUuids.length, '?').join(',');

    await db.rawUpdate(
      '''
      UPDATE guest_sessions
      SET sync_status = ?
      WHERE session_uuid IN ($placeholders)
      ''',
      [SyncStatus.synced.name, ...sessionUuids],
    );
  }

  Future<void> upsertFromRemote(GuestSessionModel session) async {
    final db = await _databaseHelper.database;

    final existing = await db.query(
      'guest_sessions',
      where: 'session_uuid = ?',
      whereArgs: [session.sessionUuid],
    );

    if (session.isDeleted == true) {
      await db.delete(
        'guest_sessions',
        where: 'session_uuid = ?',
        whereArgs: [session.sessionUuid],
      );
      return;
    }

    if (existing.isNotEmpty) {
      final localRow = existing.first;

      if (localRow['sync_status'] == SyncStatus.pending.name) {
        // Skip update to avoid overwriting local changes
        return;
      }

      final localUpdated = DateTime.tryParse(localRow['updated_at'] as String? ?? '');

      if (localUpdated != null &&
          session.updatedAt != null &&
          localUpdated.isAfter(session.updatedAt!)) {
        // Local data is newer, skip update
        return;
      }
    }

    await db.insert(
      'guest_sessions',
      session.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
