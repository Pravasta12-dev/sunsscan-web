import 'package:sun_scan/core/exception/app_exception.dart';
import 'package:sun_scan/core/sync/sync_dispatcher.dart';
import 'package:sun_scan/data/datasource/local/guest_session_local_datasource.dart';
import 'package:sun_scan/data/model/guest_activity_model.dart';

import '../../../core/exception/custom_exception.dart';
import '../../model/guest_session_model.dart';

abstract class GuestSessionLocalRepository {
  Future<GuestSessionModel?> getActiveSession(String guestUuid);
  Future<GuestSessionModel?> createSession({required String guestUuid, required String eventUuid});
  Future<void> closeSession(String sessionUuid);
  Future<List<GuestActivityModel>> getGuestActivities(String eventUuid);
}

class GuestSessionLocalRepositoryImpl implements GuestSessionLocalRepository {
  final GuestSessionLocalDatasource _localDatasource;

  GuestSessionLocalRepositoryImpl(this._localDatasource);

  factory GuestSessionLocalRepositoryImpl.create() {
    final localDatasource = GuestSessionLocalDatasource.create();
    return GuestSessionLocalRepositoryImpl(localDatasource);
  }

  @override
  Future<GuestSessionModel?> getActiveSession(String guestUuid) {
    return _localDatasource.getActiveSession(guestUuid);
  }

  @override
  Future<GuestSessionModel?> createSession({
    required String guestUuid,
    required String eventUuid,
  }) async {
    final result = await _localDatasource.createSession(guestUuid: guestUuid, eventUuid: eventUuid);
    SyncDispatcher.onLocalChange();

    return result;
  }

  @override
  Future<void> closeSession(String sessionUuid) async {
    final result = await _localDatasource.closeSession(sessionUuid);
    SyncDispatcher.onLocalChange();

    return result;
  }

  @override
  Future<List<GuestActivityModel>> getGuestActivities(String eventUuid) async {
    try {
      final result = await _localDatasource.getGuestActivities(eventUuid);
      return result;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw CustomException('Terjadi kesalahan database (guest activities)', code: -2);
    }
  }
}
