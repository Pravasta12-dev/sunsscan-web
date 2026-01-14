import 'package:sqflite/sqflite.dart';
import 'package:sun_scan/core/exception/custom_exception.dart';
import 'package:sun_scan/core/storage/database.dart';
import 'package:sun_scan/data/model/souvenir_model.dart';

import '../../../core/enum/enum.dart';

class SouvenirLocalDataSource {
  final DatabaseHelper _databaseHelper;

  SouvenirLocalDataSource(this._databaseHelper);

  factory SouvenirLocalDataSource.create() {
    final databaseHelper = DatabaseHelper();
    return SouvenirLocalDataSource(databaseHelper);
  }

  Future<List<SouvenirModel>> getSouvenirByEvent(String eventUuid) async {
    final db = await _databaseHelper.database;

    try {
      final maps = await db.rawQuery(
        '''
          SELECT 
            souvenirs.*,
            guests.name AS guest_name,
            guest_categories.name AS guest_category_name,
            CASE 
              WHEN guests.checked_in_at IS NOT NULL THEN 1
              ELSE 0
            END AS checkin_status
          FROM souvenirs
          INNER JOIN guests ON souvenirs.guest_uuid = guests.guest_uuid
          INNER JOIN guest_categories ON souvenirs.guest_category_uuid = guest_categories.category_uuid
          WHERE souvenirs.event_uuid = ? AND souvenirs.is_deleted = 0
        ''',
        [eventUuid],
      );

      return maps.map((map) => SouvenirModel.fromJson(map)).toList();
    } catch (e) {
      throw CustomException('Failed to fetch souvenirs: $e');
    }
  }

  Future<void> markSouvenirToReceivedByGuestUuid(
    String guestUuid,
    DateTime receivedAt,
  ) async {
    final db = await _databaseHelper.database;

    try {
      await db.update(
        'souvenirs',
        {
          'souvenir_status': SouvenirStatus.delivered.name,
          'received_at': receivedAt.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'sync_status': SyncStatus.pending.name,
        },
        where: 'guest_uuid = ? AND is_deleted = 0',
        whereArgs: [guestUuid],
      );
    } catch (e) {
      throw Exception('Failed to mark souvenir as received: $e');
    }
  }

  Future<void> updateSouvenir(SouvenirModel souvenir) async {
    final db = await _databaseHelper.database;

    try {
      await db.update(
        'souvenirs',
        souvenir.toJson(),
        where: 'souvenir_uuid = ?',
        whereArgs: [souvenir.souvenirUuid],
      );
    } catch (e, st) {
      print('Error updating souvenir: $e');
      print(st);
      throw Exception('Failed to update souvenir: $e');
    }
  }

  Future<void> deleteSouvenir(String souvenirUuid) async {
    final db = await _databaseHelper.database;

    // Soft delete: set is_deleted to 1
    try {
      await db.update(
        'souvenirs',
        {'is_deleted': 1},
        where: 'souvenir_uuid = ?',
        whereArgs: [souvenirUuid],
      );
    } catch (e) {
      throw Exception('Failed to delete souvenir: $e');
    }
  }

  Future<List<SouvenirModel>> getPendingSyncSouvenirs(int limit) async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'souvenirs',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pending.name],
      orderBy: 'created_at ASC',
      limit: limit,
    );

    return result.map((e) => SouvenirModel.fromJson(e)).toList();
  }

  Future<void> markSouvenirsAsSynced(List<String> souvenirUuids) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final uuid in souvenirUuids) {
      batch.update(
        'souvenirs',
        {'sync_status': SyncStatus.synced.name},
        where: 'souvenir_uuid = ?',
        whereArgs: [uuid],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> upsertFromRemote(SouvenirModel souvenir) async {
    final db = await _databaseHelper.database;

    final existing = await db.query(
      'souvenirs',
      where: 'souvenir_uuid = ?',
      whereArgs: [souvenir.souvenirUuid],
    );

    if (existing.isNotEmpty) {
      final localSync = existing.first['sync_status'];

      if (localSync == SyncStatus.pending.name) {
        // Skip updating to avoid overwriting local changes
        return;
      }

      if (souvenir.isDeleted == true) {
        // If the remote souvenir is marked as deleted, delete it locally
        await db.delete(
          'souvenirs',
          where: 'souvenir_uuid = ?',
          whereArgs: [souvenir.souvenirUuid],
        );
        return;
      }

      final localUpdatedAt = DateTime.tryParse(
        existing.first['updated_at'] as String? ?? '',
      );

      if (localUpdatedAt != null &&
          souvenir.updatedAt != null &&
          localUpdatedAt.isAfter(souvenir.updatedAt!)) {
        // Local record is newer; skip update
        return;
      }
    }

    await db.insert(
      'souvenirs',
      souvenir.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
