import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/data/repositories/local/event_local_repository.dart';

part 'event_state.dart';

class EventBloc extends Cubit<EventState> {
  EventBloc() : super(EventInitial());

  final EventLocalRepositoryImpl _eventLocalRepository =
      EventLocalRepositoryImpl.create();

  Future<void> loadEvents() async {
    emit(EventLoading());
    try {
      final events = await _eventLocalRepository.getAllEvents();
      final activeEvent = await _eventLocalRepository.getActiveEvent();
      emit(EventLoaded(events, activeEvent: activeEvent));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> createEvent(EventModel event) async {
    try {
      await _eventLocalRepository.insertEvent(event);
      await loadEvents();
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> updateEvent(EventModel event) async {
    try {
      await _eventLocalRepository.updateEvent(event);
      await loadEvents();
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> deleteEvent(String eventUuid) async {
    try {
      await _eventLocalRepository.deleteEvent(eventUuid);
      await loadEvents();
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> setActiveEvent(String eventUuid) async {
    try {
      await _eventLocalRepository.setActiveEvent(eventUuid);
      await loadEvents();
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
