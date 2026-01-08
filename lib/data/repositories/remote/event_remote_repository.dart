import 'package:sun_scan/data/model/event_model.dart';

import '../../datasource/remote/event_remote_datasource.dart';

abstract class EventRemoteRepository {
  Future<EventModel> fetchEventByCode(String eventCode);
}

class EventRemoteRepositoryImpl implements EventRemoteRepository {
  final EventRemoteDatasource _datasource;

  EventRemoteRepositoryImpl({required EventRemoteDatasource datasource})
    : _datasource = datasource;

  factory EventRemoteRepositoryImpl.create() {
    final datasource = EventRemoteDatasourceImpl.create();

    return EventRemoteRepositoryImpl(datasource: datasource);
  }

  @override
  Future<EventModel> fetchEventByCode(String eventCode) async {
    try {
      return await _datasource.fetchEventByCode(eventCode);
    } catch (e) {
      rethrow;
    }
  }
}
