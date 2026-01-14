import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/repositories/remote/event_remote_repository.dart';

import '../../../../data/model/event_model.dart';

part 'event_web_state.dart';

class EventWebBloc extends Cubit<EventWebState> {
  final EventRemoteRepository _eventRemoteRepository = EventRemoteRepositoryImpl.create();

  EventWebBloc() : super(EventWebInitial());

  Future<void> fetchEventByCode(String eventCode) async {
    emit(EventWebLoading());
    try {
      final event = await _eventRemoteRepository.fetchEventByCode(eventCode);

      emit(EventWebLoaded(event: event));
    } catch (e) {
      emit(EventWebError(message: e.toString()));
    }
  }
}
