import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sun_scan/core/enum/enum.dart';
import 'package:sun_scan/core/storage/database.dart';
import 'package:sun_scan/data/model/guest_category_model.dart';

class GuestCategoryDatasource {
  final DatabaseHelper _databaseHelper;

  GuestCategoryDatasource(this._databaseHelper);

  factory GuestCategoryDatasource.create() {
    return GuestCategoryDatasource(DatabaseHelper());
  }

  Future<List<GuestCategoryModel>> getAllCategories({
    required String eventUuid,
  }) async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'guest_categories',
      where: 'event_uuid = ?',
      whereArgs: [eventUuid],
    );

    return result.map((e) => GuestCategoryModel.fromJson(e)).toList();
  }

  Future<List<GuestCategoryModel>> getPendingSyncGuestsCategories(
    int limit,
  ) async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'guest_categories',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pending.name],
      orderBy: 'created_at ASC',
      limit: limit,
    );

    return result.map((e) => GuestCategoryModel.fromJson(e)).toList();
  }

  Future<void> markCategoriesAsSynced(List<String> categoryUuids) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final uuid in categoryUuids) {
      batch.update(
        'guest_categories',
        {'sync_status': SyncStatus.synced.name},
        where: 'category_uuid = ?',
        whereArgs: [uuid],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> upsertFromRemote(GuestCategoryModel category) async {
    final db = await _databaseHelper.database;

    final existing = await db.query(
      'guest_categories',
      where: 'category_uuid = ?',
      whereArgs: [category.categoryUuid],
    );

    if (existing.isEmpty) {
      final localSync = existing.first['sync_status'];

      if (localSync == SyncStatus.pending.name) {
        // Skip updating to avoid overwriting local changes
        return;
      }

      final localUpdatedAt = DateTime.tryParse(
        existing.first['updated_at'] as String? ?? '',
      );

      if (localUpdatedAt != null &&
          category.updatedAt != null &&
          localUpdatedAt.isAfter(category.updatedAt!)) {
        // Skip updating as local data is more recent
        return;
      }

      await db.insert(
        'guest_categories',
        category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
