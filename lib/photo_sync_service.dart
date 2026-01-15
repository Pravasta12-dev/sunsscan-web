import 'package:sun_scan/data/datasource/remote/guest_photo_remote_datasource.dart';

import 'data/datasource/local/guest_photo_local_datasource.dart';

class PhotoSyncService {
  final GuestPhotoLocalDatasource _guestPhotoLocalDatasource;
  final GuestPhotoRemoteDatasource _guestPhotoRemoteDatasource;

  PhotoSyncService({
    required GuestPhotoLocalDatasource guestPhotoLocalDatasource,
    required GuestPhotoRemoteDatasource guestPhotoRemoteDatasource,
  }) : _guestPhotoLocalDatasource = guestPhotoLocalDatasource,
       _guestPhotoRemoteDatasource = guestPhotoRemoteDatasource;

  Future<void> syncPendingPhotos() async {
    final pending = await _guestPhotoLocalDatasource.getPendingPhotos(10);

    for (final photo in pending) {
      String? fileUrl = photo.fileUrl;

      // 1️⃣ UPLOAD FILE (hanya jika belum ada fileUrl dan belum di-delete)
      if (!photo.isDeleted && (fileUrl == null || fileUrl.isEmpty)) {
        fileUrl = await _guestPhotoRemoteDatasource.upload(photo);
        // 2️⃣ SIMPAN file_url ke local
        await _guestPhotoLocalDatasource.markPhotoUploaded(photo.photoUuid, fileUrl);
      }

      // 3️⃣ AMBIL DATA TERBARU dari DB (untuk mendapatkan isPrimary yang sudah di-update)
      final updatedPhoto = await _guestPhotoLocalDatasource.getPhotoByUuid(photo.photoUuid);
      if (updatedPhoto == null) continue;

      // 4️⃣ SYNC METADATA dengan data terbaru (termasuk is_deleted)
      await _guestPhotoRemoteDatasource.sync([updatedPhoto.copyWith(fileUrl: fileUrl)]);

      // 5️⃣ MARK SYNCED
      await _guestPhotoLocalDatasource.markPhotoAsSynced(photoUuid: photo.photoUuid);
    }
  }
}
