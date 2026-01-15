import 'package:sqflite/sqflite.dart';
import 'package:sun_scan/core/storage/database.dart';

import '../../model/guest_photo_model.dart';
import '../../../core/enum/enum.dart';

class GuestPhotoLocalDatasource {
  final DatabaseHelper _databaseHelper;

  GuestPhotoLocalDatasource(this._databaseHelper);

  factory GuestPhotoLocalDatasource.create() {
    return GuestPhotoLocalDatasource(DatabaseHelper());
  }

  // =====================================================
  // INSERT PHOTO
  // =====================================================
  Future<void> insertPhoto(GuestPhotoModel photo) async {
    final db = await _databaseHelper.database;
    await db.insert('guest_photos', photo.toJson());
  }

  // =====================================================
  // UPDATE PHOTO
  // =====================================================
  Future<void> setPrimaryPhoto(String photoUuid, String guestUuid) async {
    final db = await _databaseHelper.database;

    await db.transaction((txn) async {
      // reset semua primary (set sync_status = pending agar foto lama juga di-sync dengan isPrimary = 0)
      await txn.update(
        'guest_photos',
        {'is_primary': 0, 'sync_status': SyncStatus.pending.name},
        where: 'guest_uuid = ?',
        whereArgs: [guestUuid],
      );

      // set foto baru
      await txn.update(
        'guest_photos',
        {
          'is_primary': 1,
          'updated_at': DateTime.now().toIso8601String(),
          'sync_status': SyncStatus.pending.name,
        },
        where: 'photo_uuid = ?',
        whereArgs: [photoUuid],
      );
    });
  }

  // =====================================================
  // QUERY PHOTO BY GUEST
  // =====================================================
  Future<List<GuestPhotoModel>> getPhotosByGuest(String guestUuid, {PhotoType? photoType}) async {
    final db = await _databaseHelper.database;

    final where = StringBuffer('guest_uuid = ? AND is_deleted = 0');
    final args = <dynamic>[guestUuid];

    if (photoType != null) {
      where.write(' AND photo_type = ?');
      args.add(photoType.name);
    }

    final result = await db.query(
      'guest_photos',
      where: where.toString(),
      whereArgs: args,
      orderBy: 'created_at ASC',
    );

    return result.map(GuestPhotoModel.fromJson).toList();
  }

  // =====================================================
  // SOFT DELETE PHOTO
  // =====================================================
  Future<void> deletePhoto(String photoUuid) async {
    final db = await _databaseHelper.database;

    await db.update(
      'guest_photos',
      {
        'is_deleted': 1,
        'deleted_at': DateTime.now().toIso8601String(),
        'sync_status': SyncStatus.pending.name,
      },
      where: 'photo_uuid = ?',
      whereArgs: [photoUuid],
    );
  }

  // =====================================================
  // SYNC – PENDING PHOTOS
  // =====================================================
  Future<List<GuestPhotoModel>> getPendingPhotos(int limit) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'guest_photos',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pending.name],
      orderBy: 'created_at ASC',
      limit: limit,
    );

    return result.map(GuestPhotoModel.fromJson).toList();
  }

  Future<GuestPhotoModel?> getPhotoByUuid(String photoUuid) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'guest_photos',
      where: 'photo_uuid = ?',
      whereArgs: [photoUuid],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return GuestPhotoModel.fromJson(result.first);
  }

  Future<void> markPhotoAsSynced({required String photoUuid}) async {
    final db = await _databaseHelper.database;

    await db.update(
      'guest_photos',
      {'sync_status': SyncStatus.synced.name, 'updated_at': DateTime.now().toIso8601String()},
      where: 'photo_uuid = ?',
      whereArgs: [photoUuid],
    );
  }

  Future<void> markPhotoUploaded(String photoUuid, String fileUrl) async {
    final db = await _databaseHelper.database;
    await db.update(
      'guest_photos',
      {'file_url': fileUrl, 'updated_at': DateTime.now().toIso8601String()},
      where: 'photo_uuid = ?',
      whereArgs: [photoUuid],
    );
  }

  Future<void> upsertFromRemote(GuestPhotoModel photo) async {
    final db = await _databaseHelper.database;

    final local = await db.query(
      'guest_photos',
      where: 'photo_uuid = ?',
      whereArgs: [photo.photoUuid],
    );

    if (photo.isDeleted == true) {
      await db.delete('guest_photos', where: 'photo_uuid = ?', whereArgs: [photo.photoUuid]);
      return;
    }

    if (local.isNotEmpty) {
      final localRow = local.first;

      if (localRow['sync_status'] == SyncStatus.pending.name) {
        // Abaikan update jika status lokal masih pending
        return;
      }

      final localUpdated = DateTime.tryParse(localRow['updated_at'] as String? ?? '');

      if (localUpdated != null &&
          photo.updatedAt != null &&
          localUpdated.isAfter(photo.updatedAt!)) {
        // Abaikan update jika data lokal lebih baru
        return;
      }

      // Pertahankan filePath lokal, karena filePath dari server adalah URL path bukan local path
      final photoData = photo.toJson();
      photoData['file_path'] = localRow['file_path']; // Keep local file path

      await db.insert('guest_photos', photoData, conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      // Data baru dari server, tapi tidak ada file lokal (skip atau tandai untuk download)
      // Untuk saat ini, simpan dengan filePath dari server (akan error jika coba upload ulang)
      await db.insert('guest_photos', photo.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
