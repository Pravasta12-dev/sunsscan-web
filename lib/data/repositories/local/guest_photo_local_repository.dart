import 'package:sun_scan/data/model/guest_photo_model.dart';

import '../../../core/exception/custom_exception.dart';
import '../../datasource/local/guest_photo_local_datasource.dart';

abstract class GuestPhotoLocalRepository {
  Future<void> insertPhoto(GuestPhotoModel photo);
  Future<List<GuestPhotoModel>> getPhotosByGuest(String guestUuid, {PhotoType? photoType});
  Future<void> setPrimaryPhoto(String photoUuid, String guestUuid);
  Future<void> deletePhoto(String photoUuid);
}

class GuestPhotoLocalRepositoryImpl implements GuestPhotoLocalRepository {
  final GuestPhotoLocalDatasource _datasource;

  GuestPhotoLocalRepositoryImpl({required GuestPhotoLocalDatasource datasource})
    : _datasource = datasource;

  factory GuestPhotoLocalRepositoryImpl.create() {
    return GuestPhotoLocalRepositoryImpl(datasource: GuestPhotoLocalDatasource.create());
  }

  @override
  Future<void> insertPhoto(GuestPhotoModel photo) async {
    try {
      await _datasource.insertPhoto(photo);
    } catch (e) {
      throw _dbError();
    }
  }

  @override
  Future<void> setPrimaryPhoto(String photoUuid, String guestUuid) async {
    try {
      await _datasource.setPrimaryPhoto(photoUuid, guestUuid);
    } catch (e) {
      throw _dbError();
    }
  }

  @override
  Future<List<GuestPhotoModel>> getPhotosByGuest(String guestUuid, {PhotoType? photoType}) async {
    try {
      return await _datasource.getPhotosByGuest(guestUuid, photoType: photoType);
    } catch (e) {
      throw _dbError();
    }
  }

  @override
  Future<void> deletePhoto(String photoUuid) async {
    try {
      await _datasource.deletePhoto(photoUuid);
    } catch (e) {
      throw _dbError();
    }
  }
}

dynamic _dbError() => throw CustomException('Terjadi kesalahan database (guest photo)', code: -2);
