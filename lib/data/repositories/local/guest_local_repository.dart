import 'package:sun_scan/data/model/guests_model.dart';

import '../../../core/exception/custom_exception.dart';
import '../../datasource/local/guest_local_datasource.dart';

abstract class GuestLocalRepository {
  Future<void> insertGuest(GuestsModel guest);
  Future<void> insertGuestsBatch({
    required List<GuestsModel> guests,
    required void Function(int current, int total) onProgress,
  });
  Future<List<GuestsModel>> getGuestsByEventId(String eventUuid);
  Future<GuestsModel?> getGuestByQrValue(String qrValue);
  Future<void> updateGuest(GuestsModel guest);
  Future<void> deleteGuest(String guestUuid);
  Future<void> checkInGuest(String guestUuid, String checkInTime);
  Future<void> checkOutGuest(String guestUuid, String checkOutTime);
}

class GuestLocalRepositoryImpl implements GuestLocalRepository {
  final GuestLocalDatasource _datasource;

  GuestLocalRepositoryImpl({required GuestLocalDatasource datasource})
    : _datasource = datasource;

  @override
  Future<void> insertGuest(GuestsModel guest) async {
    try {
      await _datasource.insertGuest(guest);
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> insertGuestsBatch({
    required List<GuestsModel> guests,
    required void Function(int current, int total) onProgress,
  }) async {
    try {
      await _datasource.insertGuestsBatch(
        guests: guests,
        onProgress: onProgress,
      );
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<List<GuestsModel>> getGuestsByEventId(String eventUuid) async {
    try {
      return await _datasource.getGuestsByEventId(eventUuid);
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<GuestsModel?> getGuestByQrValue(String qrValue) async {
    try {
      return await _datasource.getGuestByQrValue(qrValue);
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> updateGuest(GuestsModel guest) async {
    try {
      await _datasource.updateGuest(guest);
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> deleteGuest(String guestUuid) async {
    try {
      await _datasource.deleteGuest(guestUuid);
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> checkInGuest(String guestUuid, String checkInTime) async {
    try {
      await _datasource.checkInGuest(guestUuid, checkInTime);
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> checkOutGuest(String guestUuid, String checkOutTime) async {
    try {
      await _datasource.checkOutGuest(guestUuid, checkOutTime);
    } catch (e) {
      return _dbError();
    }
  }

  dynamic _dbError() => throw CustomException(
    'Terjadi kesalahan database',
    code: 'DATABASE_ERROR',
  );

  factory GuestLocalRepositoryImpl.create() {
    final datasource = GuestLocalDatasource.create();
    return GuestLocalRepositoryImpl(datasource: datasource);
  }
}
