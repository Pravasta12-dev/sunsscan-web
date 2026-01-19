import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/model/guest_activity_model.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/data/repositories/local/guest_local_repository.dart';
import 'package:sun_scan/data/repositories/local/guest_session_local_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/model/guest_session_model.dart';

part 'guest_session_state.dart';

class GuestSessionBloc extends Cubit<GuestSessionState> {
  final GuestSessionLocalRepository _sessionRepo = GuestSessionLocalRepositoryImpl.create();
  final GuestLocalRepository _guestRepo = GuestLocalRepositoryImpl.create();

  GuestSessionBloc() : super(GuestSessionInitial());

  Future<void> scanQr(String qrValue) async {
    emit(GuestSessionChecking());

    try {
      final guest = await _guestRepo.getGuestByQrValue(qrValue);
      if (guest == null) {
        emit(GuestSessionError('Tamu tidak ditemukan'));
        return;
      }

      final activeSession = await _sessionRepo.getActiveSession(guest.guestUuid!);

      if (activeSession != null) {
        await _checkOut(guest, activeSession);
      } else {
        await _checkIn(guest);
      }
    } catch (e) {
      emit(GuestSessionError('Terjadi kesalahan: $e'));
    }
  }

  Future<void> _checkIn(GuestsModel guest) async {
    final now = DateTime.now().toUtc();

    final session = GuestSessionModel(
      sessionUuid: const Uuid().v4(),
      guestUuid: guest.guestUuid!,
      eventUuid: guest.eventUuid,
      checkinAt: now,
      createdAt: now,
    );

    await _sessionRepo.createSession(guestUuid: guest.guestUuid!, eventUuid: guest.eventUuid);

    // Reload guest data to get updated lastCheckInAt
    final updatedGuest = await _guestRepo.getGuestByQrValue(guest.qrValue);

    emit(GuestCheckInSuccess(updatedGuest ?? guest, session));
  }

  Future<void> _checkOut(GuestsModel guest, GuestSessionModel session) async {
    final now = DateTime.now().toUtc();

    await _sessionRepo.closeSession(session.sessionUuid);

    emit(GuestCheckOutSuccess(session.copyWith(checkoutAt: now)));
  }

  Future<List<GuestActivityModel>> getGuestActivities(String eventUuid) async {
    emit(GuestSessionLoading());

    try {
      final activities = await _sessionRepo.getGuestActivities(eventUuid);
      emit(GuestSessionLoaded(activities));
      return activities;
    } catch (e) {
      emit(GuestSessionLoadError('Terjadi kesalahan: $e'));
      return [];
    }
  }
}
