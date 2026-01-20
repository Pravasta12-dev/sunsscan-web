import 'package:sqflite/sqflite.dart';
import 'package:sun_scan/core/enum/enum.dart';
import 'package:sun_scan/core/exception/custom_exception.dart';
import 'package:sun_scan/core/storage/database.dart';
import 'package:sun_scan/data/model/greeting_screen_model.dart';
import 'package:uuid/uuid.dart';

class GreetingLocalDatasource {
  final DatabaseHelper _databaseHelper;

  GreetingLocalDatasource(this._databaseHelper);

  factory GreetingLocalDatasource.create() {
    return GreetingLocalDatasource(DatabaseHelper());
  }

  Future<void> insertGreetingScreen({
    required GreetingScreenModel greetingScreen,
  }) async {
    final db = await _databaseHelper.database;

    try {
      final greetingUuid = Uuid().v4();

      await db.insert(
        'greeting_screens',
        greetingScreen
            .copyWith(
              greetingUuid: greetingUuid,
              syncStatus: SyncStatus.pending,
            )
            .toJson(),
      );
    } catch (e) {
      throw CustomException('Failed to insert greeting screen');
    }
  }

  Future<void> updateGreetingScreen({
    required GreetingScreenModel greetingScreen,
  }) async {
    final db = await _databaseHelper.database;

    try {
      await db.update(
        'greeting_screens',
        greetingScreen
            .copyWith(syncStatus: SyncStatus.pending, updatedAt: DateTime.now())
            .toJson(),
        where: 'greeting_uuid = ?',
        whereArgs: [greetingScreen.greetingUuid],
      );
    } catch (e) {
      throw CustomException('Failed to update greeting screen');
    }
  }

  Future<void> deleteGreetingScreen({required String greetingUuid}) async {
    final db = await _databaseHelper.database;

    try {
      await db.update(
        'greeting_screens',
        {
          'is_deleted': 1,
          'sync_status': SyncStatus.pending.name,
          'deleted_at': DateTime.now().toUtc().toIso8601String(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        where: 'greeting_uuid = ?',
        whereArgs: [greetingUuid],
      );
    } catch (e) {
      throw CustomException('Failed to delete greeting screen');
    }
  }

  Future<List<GreetingScreenModel>> getGreetingScreensByEventUuid({
    required String eventUuid,
  }) async {
    final db = await _databaseHelper.database;

    try {
      final maps = await db.query(
        'greeting_screens',
        where: 'event_uuid = ? AND is_deleted = 0',
        whereArgs: [eventUuid],
      );

      return List.generate(maps.length, (i) {
        return GreetingScreenModel.fromJson(maps[i]);
      });
    } catch (e) {
      throw CustomException('Failed to fetch greeting screens');
    }
  }

  Future<List<GreetingScreenModel>> getPendingGreetingScreens(int limit) async {
    final db = await _databaseHelper.database;

    try {
      final maps = await db.query(
        'greeting_screens',
        where: 'sync_status = ?',
        whereArgs: [SyncStatus.pending.name],
        orderBy: 'created_at ASC',
        limit: limit,
      );

      return List.generate(maps.length, (i) {
        return GreetingScreenModel.fromJson(maps[i]);
      });
    } catch (e) {
      throw CustomException('Failed to fetch pending greeting screens');
    }
  }

  Future<void> markGreetingScreensAsSynced(List<String> greetingUuids) async {
    final db = await _databaseHelper.database;

    if (greetingUuids.isEmpty) return;

    try {
      final placeholders = List.filled(greetingUuids.length, '?').join(', ');
      await db.rawUpdate(
        'UPDATE greeting_screens SET sync_status = ? WHERE greeting_uuid IN ($placeholders)',
        [SyncStatus.synced.name, ...greetingUuids],
      );
    } catch (e) {
      throw CustomException('Failed to mark greeting screens as synced');
    }
  }

  Future<void> upsertFormRemote(GreetingScreenModel greetingScreen) async {
    final db = await _databaseHelper.database;

    final existing = await db.query(
      'greeting_screens',
      where: 'greeting_uuid = ?',
      whereArgs: [greetingScreen.greetingUuid],
    );

    if (greetingScreen.isDeleted == true) {
      await db.delete(
        'greeting_screens',
        where: 'greeting_uuid = ?',
        whereArgs: [greetingScreen.greetingUuid],
      );
      return;
    }

    if (existing.isNotEmpty) {
      final localRow = existing.first;

      final localSyncStatus = localRow['sync_status'] as String?;
      final localUpdatedAt = DateTime.tryParse(
        localRow['updated_at'] as String? ?? '',
      );

      if (localSyncStatus == SyncStatus.pending.name) {
        // Skip updating to avoid overwriting local changes
        return;
      }

      if (localUpdatedAt != null &&
          greetingScreen.updatedAt != null &&
          localUpdatedAt.isAfter(greetingScreen.updatedAt!)) {
        // Local data is newer, skip update
        return;
      }
    }

    // Insert or update
    await db.insert(
      'greeting_screens',
      greetingScreen.copyWith(syncStatus: SyncStatus.synced).toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
