import '../../datasource/remote/guest_remote_datasource.dart';
import '../../model/guests_model.dart';

abstract class GuestRemoteRepository {
  Future<List<GuestsModel>> fetchGuestsByEventId(String eventId);
  Future<String> deleteGuest(String guestUuid);
}

class GuestRemoteRepositoryImpl implements GuestRemoteRepository {
  final GuestRemoteDatasource _datasource;

  GuestRemoteRepositoryImpl({required GuestRemoteDatasource datasource}) : _datasource = datasource;

  factory GuestRemoteRepositoryImpl.create() {
    final datasource = GuestRemoteDatasourceImpl.create();

    return GuestRemoteRepositoryImpl(datasource: datasource);
  }

  @override
  Future<List<GuestsModel>> fetchGuestsByEventId(String eventId) async {
    try {
      return await _datasource.fetchGuestsByEventId(eventId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteGuest(String guestUuid) async {
    try {
      return await _datasource.deleteGuest(guestUuid);
    } catch (e) {
      rethrow;
    }
  }
}
