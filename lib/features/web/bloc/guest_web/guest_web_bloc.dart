import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/repositories/remote/guest_remote_repository.dart';

import '../../../../data/model/guests_model.dart';

part 'guest_web_state.dart';

class GuestWebBloc extends Cubit<GuestWebState> {
  final GuestRemoteRepository _guestLocalRepository =
      GuestRemoteRepositoryImpl.create();

  GuestWebBloc() : super(GuestWebInitial());

  Future<void> fetchGuestsByEventId(String eventUuid) async {
    emit(GuestWebLoading());
    try {
      final guests = await _guestLocalRepository.fetchGuestsByEventId(
        eventUuid,
      );
      emit(GuestWebLoaded(guests: guests));
    } catch (e) {
      emit(GuestWebError(message: e.toString()));
    }
  }
}
