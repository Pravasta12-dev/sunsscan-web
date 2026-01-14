import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/model/params/create_guest_param.dart';
import 'package:sun_scan/data/repositories/remote/guest_remote_repository.dart';

import '../../../../data/model/guests_model.dart';

part 'guest_web_state.dart';

class GuestWebBloc extends Cubit<GuestWebState> {
  final GuestRemoteRepository _guestRemoteRepository = GuestRemoteRepositoryImpl.create();

  GuestWebBloc() : super(GuestWebInitial());

  Future<void> fetchGuestsByEventId(String eventUuid) async {
    emit(GuestWebLoading());
    try {
      final guests = await _guestRemoteRepository.fetchGuestsByEventId(eventUuid);
      emit(GuestWebLoaded(guests: guests));
    } catch (e) {
      emit(GuestWebError(message: e.toString()));
    }
  }

  Future<void> deleteGuest(String guestUuid, String eventUuid) async {
    emit(GuestWebLoading());
    try {
      await _guestRemoteRepository.deleteGuest(guestUuid);

      // Refresh the guest list after deletion
      final updatedGuests = await _guestRemoteRepository.fetchGuestsByEventId(eventUuid);
      emit(GuestWebLoaded(guests: updatedGuests));
    } catch (e) {
      emit(GuestWebError(message: e.toString()));
    }
  }

  Future<void> createGuest(CreateGuestParam guest) async {
    emit(GuestWebLoading());

    try {
      await _guestRemoteRepository.createGuest(guest);

      // Refresh the guest list after creation
      final updatedGuests = await _guestRemoteRepository.fetchGuestsByEventId(guest.eventId);
      emit(GuestWebLoaded(guests: updatedGuests));
    } catch (e) {
      emit(GuestWebError(message: e.toString()));
    }
  }

  Future<void> updateGuest(CreateGuestParam guest) async {
    emit(GuestWebLoading());

    try {
      await _guestRemoteRepository.updateGuest(guest);

      // Refresh the guest list after update
      final updatedGuests = await _guestRemoteRepository.fetchGuestsByEventId(guest.eventId);
      emit(GuestWebLoaded(guests: updatedGuests));
    } catch (e) {
      emit(GuestWebError(message: e.toString()));
    }
  }
}
