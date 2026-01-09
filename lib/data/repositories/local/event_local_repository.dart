import 'package:sun_scan/core/sync/sync_dispatcher.dart';

import '../../../core/exception/custom_exception.dart';
import '../../datasource/local/event_local_datasource.dart';
import '../../model/event_model.dart';

abstract class EventLocalRepository {
  Future<void> insertEvent(EventModel event);
  Future<List<EventModel>> getAllEvents();
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventUuid);
  Future<EventModel?> getActiveEvent();
  Future<void> setActiveEvent(String eventUuid);
}

class EventLocalRepositoryImpl implements EventLocalRepository {
  final EventLocalDatasource _datasource;

  EventLocalRepositoryImpl({required EventLocalDatasource datasource}) : _datasource = datasource;

  @override
  Future<void> deleteEvent(String eventUuid) async {
    try {
      await _datasource.deleteEvent(eventUuid);
      SyncDispatcher.onLocalChange();
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<EventModel?> getActiveEvent() async {
    try {
      return await _datasource.getActiveEvent();
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      return await _datasource.getAllEvents();
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> insertEvent(EventModel event) async {
    try {
      await _datasource.insertEvent(event);
      SyncDispatcher.onLocalChange();
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> setActiveEvent(String eventUuid) async {
    try {
      await _datasource.setActiveEvent(eventUuid);
      SyncDispatcher.onLocalChange();
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    try {
      await _datasource.updateEvent(event);
      SyncDispatcher.onLocalChange();
    } catch (e) {
      return _dbError();
    }
  }

  factory EventLocalRepositoryImpl.create() {
    final datasource = EventLocalDatasource.create();
    return EventLocalRepositoryImpl(datasource: datasource);
  }
}

dynamic _dbError() => throw CustomException('Terjadi kesalahan database', code: 'DATABASE_ERROR');
