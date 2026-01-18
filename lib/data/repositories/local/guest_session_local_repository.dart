import 'package:sun_scan/data/datasource/local/guest_session_local_datasource.dart';

import '../../model/guest_session_model.dart';

abstract class GuestSessionLocalRepository {
  Future<GuestSessionModel?> getActiveSession(String guestUuid);
  Future<GuestSessionModel?> createSession({
    required String guestUuid,
    required String eventUuid,
  });
  Future<void> closeSession(String sessionUuid);
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
  }) {
    return _localDatasource.createSession(
      guestUuid: guestUuid,
      eventUuid: eventUuid,
    );
  }

  @override
  Future<void> closeSession(String sessionUuid) {
    return _localDatasource.closeSession(sessionUuid);
  }
}
