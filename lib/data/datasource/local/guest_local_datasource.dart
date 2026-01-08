import 'package:sqflite/sqflite.dart';
import 'package:sun_scan/core/storage/database.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:uuid/uuid.dart';

import '../../../core/enum/enum.dart';

class GuestLocalDatasource {
  final DatabaseHelper _databaseHelper;

  GuestLocalDatasource({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper;

  factory GuestLocalDatasource.create() {
    return GuestLocalDatasource(databaseHelper: DatabaseHelper());
  }

  // =====================================================
  // INSERT SINGLE GUEST
  // =====================================================
  Future<void> insertGuest(GuestsModel guestData) async {
    final db = await _databaseHelper.database;

    final categoryUuid = guestData.guestCategoryUuid;
    final categoryName = guestData.guestCategoryName;

    final newGuest = guestData.copyWith(
      guestUuid: const Uuid().v4(),
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    // await db.insert('guests', newGuest.toJson());
    await db.transaction((txn) async {
      var catUuid = const Uuid().v4();

      if (categoryUuid == null && categoryName != null) {
        await txn.insert('guest_categories', {
          'category_uuid': catUuid,
          'event_uuid': guestData.eventUuid,
          'name': categoryName,
          'created_at': DateTime.now().toIso8601String(),
          'sync_status': SyncStatus.pending.name,
        });
      }

      await txn.insert(
        'guests',
        newGuest
            .copyWith(
              guestCategoryUuid: categoryUuid ?? catUuid,
              guestCategoryName: categoryName,
            )
            .toJson(),
      );
    });
  }

  // =====================================================
  // INSERT BATCH (CSV IMPORT)
  // =====================================================
  Future<void> insertGuestsBatch({
    required List<GuestsModel> guests,
    required void Function(int current, int total) onProgress,
    int batchSize = 10,
  }) async {
    final db = await _databaseHelper.database;
    final total = guests.length;
    int inserted = 0;

    for (int i = 0; i < total; i += batchSize) {
      final batch = db.batch();
      final end = (i + batchSize < total) ? i + batchSize : total;
      final currentBatch = guests.sublist(i, end);

      for (final guest in currentBatch) {
        final newGuest = guest.copyWith(
          guestUuid: const Uuid().v4(),
          updatedAt: DateTime.now(),
          syncStatus: SyncStatus.pending,
        );
        batch.insert('guests', newGuest.toJson());
      }

      await batch.commit(noResult: true);
      inserted += currentBatch.length;
      onProgress(inserted, total);
    }
  }

  // =====================================================
  // QUERY
  // =====================================================
  Future<List<GuestsModel>> getGuestsByEventId(String eventUuid) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'guests',
      where: 'event_uuid = ?',
      whereArgs: [eventUuid],
    );

    return maps.map(GuestsModel.fromJson).toList();
  }

  Future<GuestsModel?> getGuestByQrValue(String qrValue) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'guests',
      where: 'qr_value = ?',
      whereArgs: [qrValue],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return GuestsModel.fromJson(maps.first);
  }

  // =====================================================
  // UPDATE DATA TAMU (EDIT)
  // =====================================================
  Future<void> updateGuest(GuestsModel guestData) async {
    final db = await _databaseHelper.database;

    final categoryUuid = guestData.guestCategoryUuid;
    final categoryName = guestData.guestCategoryName;

    final updatedGuest = guestData.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    await db.transaction((txn) async {
      var catUuid = categoryUuid;

      // Jika kategori baru (nama ada tapi uuid null), create kategori dulu
      if (categoryUuid == null && categoryName != null) {
        catUuid = const Uuid().v4();

        await txn.insert('guest_categories', {
          'category_uuid': catUuid,
          'event_uuid': guestData.eventUuid,
          'name': categoryName,
          'created_at': DateTime.now().toIso8601String(),
          'sync_status': SyncStatus.pending.name,
        });
      }

      // Update guest dengan categoryUuid yang benar
      await txn.update(
        'guests',
        updatedGuest
            .copyWith(
              guestCategoryUuid: catUuid,
              guestCategoryName: categoryName,
            )
            .toJson(),
        where: 'guest_uuid = ?',
        whereArgs: [guestData.guestUuid],
      );
    });
  }

  // =====================================================
  // DELETE
  // =====================================================
  Future<void> deleteGuest(String guestUuid) async {
    final db = await _databaseHelper.database;

    await db.delete('guests', where: 'guest_uuid = ?', whereArgs: [guestUuid]);
  }

  // =====================================================
  // CHECK-IN
  // =====================================================
  Future<void> checkInGuest(String guestUuid, String checkInTime) async {
    final db = await _databaseHelper.database;

    await db.update(
      'guests',
      {
        'is_checked_in': 1,
        'checked_in_at': checkInTime,
        'updated_at': DateTime.now().toIso8601String(),
        'sync_status': SyncStatus.pending.name,
      },
      where: 'guest_uuid = ?',
      whereArgs: [guestUuid],
    );
  }

  // =====================================================
  // CHECK-OUT
  // =====================================================
  Future<void> checkOutGuest(String guestUuid, String checkOutTime) async {
    final db = await _databaseHelper.database;

    await db.update(
      'guests',
      {
        'is_checked_in': 0,
        'checked_out_at': checkOutTime,
        'updated_at': DateTime.now().toIso8601String(),
        'sync_status': SyncStatus.pending.name,
      },
      where: 'guest_uuid = ?',
      whereArgs: [guestUuid],
    );
  }

  // =====================================================
  // SYNC – PUSH
  // =====================================================
  Future<List<GuestsModel>> getPendingSyncGuests(int limit) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'guests',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pending.name],
      orderBy: 'updated_at ASC',
      limit: limit,
    );

    return result.map(GuestsModel.fromJson).toList();
  }

  Future<void> markGuestsAsSynced(List<String> guestUuids) async {
    if (guestUuids.isEmpty) return;

    final db = await _databaseHelper.database;
    final placeholders = List.filled(guestUuids.length, '?').join(',');

    await db.rawUpdate(
      '''
      UPDATE guests
      SET sync_status = ?
      WHERE guest_uuid IN ($placeholders)
      ''',
      [SyncStatus.synced.name, ...guestUuids],
    );
  }

  // =====================================================
  // SYNC – PULL (SERVER → LOCAL)
  // =====================================================
  Future<void> upsertFromRemote(GuestsModel remote) async {
    final db = await _databaseHelper.database;

    final local = await db.query(
      'guests',
      where: 'guest_uuid = ?',
      whereArgs: [remote.guestUuid],
    );

    if (local.isNotEmpty) {
      final localSync = local.first['sync_status'];

      // ❌ pending lokal = jangan di-overwrite
      if (localSync == SyncStatus.pending.name) return;

      final localUpdated = DateTime.tryParse(
        local.first['updated_at'] as String? ?? '',
      );

      if (localUpdated != null &&
          remote.updatedAt != null &&
          localUpdated.isAfter(remote.updatedAt!)) {
        return;
      }
    }

    await db.insert(
      'guests',
      remote.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
