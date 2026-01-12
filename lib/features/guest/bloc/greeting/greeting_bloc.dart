import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/repositories/local/greeting_local_repository.dart';

import '../../../../data/model/greeting_screen_model.dart';

part 'greeting_state.dart';

class GreetingBloc extends Cubit<GreetingState> {
  final GreetingLocalRepository _greetingRepository = GreetingLocalRepositoryImpl.create();

  GreetingBloc() : super(GreetingInitial());

  Future<void> loadGreetings(String eventUuid) async {
    emit(GreetingLoadInProgress());
    try {
      final greetings = await _greetingRepository.getGreetingScreensByEventUuid(
        eventUuid: eventUuid,
      );
      emit(GreetingLoadSuccess(greetingScreens: greetings));
    } catch (e) {
      emit(GreetingLoadFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addGreeting(GreetingScreenModel greetingScreen) async {
    try {
      await _greetingRepository.insertGreetingScreen(greetingScreen: greetingScreen);
      // Reload greetings after adding
      await loadGreetings(greetingScreen.eventUuid);
    } catch (e) {
      emit(GreetingLoadFailure(errorMessage: e.toString()));
    }
  }

  Future<void> updateGreeting(GreetingScreenModel greetingScreen) async {
    try {
      await _greetingRepository.updateGreetingScreen(greetingScreen: greetingScreen);
      // Reload greetings after updating
      await loadGreetings(greetingScreen.eventUuid);
    } catch (e) {
      emit(GreetingLoadFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteGreeting(String greetingUuid, String eventUuid) async {
    try {
      await _greetingRepository.deleteGreetingScreen(greetingUuid: greetingUuid);
      // Reload greetings after deleting
      await loadGreetings(eventUuid);
    } catch (e) {
      emit(GreetingLoadFailure(errorMessage: e.toString()));
    }
  }
}
