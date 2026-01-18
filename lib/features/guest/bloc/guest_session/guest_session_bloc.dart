import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/data/repositories/local/guest_local_repository.dart';
import 'package:sun_scan/data/repositories/local/guest_session_local_repository.dart';

import '../../../../data/model/guest_session_model.dart';

part 'guest_session_state.dart';

class GuestSessionBloc extends Cubit<GuestSessionState> {
  final GuestSessionLocalRepository _guestSessionLocalRepository =
      GuestSessionLocalRepositoryImpl.create();

  final GuestLocalRepository _guestLocalRepository =
      GuestLocalRepositoryImpl.create();

  GuestSessionBloc() : super(GuestSessionInitial());

  Future<void> scanQr(String qrValue) async {
    emit(GuestSessionChecking());
    try {
      final guest = await _guestLocalRepository.getGuestByQrValue(qrValue);
      if (guest == null) {
        emit(GuestSessionError('Tamu tidak ditemukan'));
        return;
      }

      final activeSession = await _guestSessionLocalRepository.getActiveSession(
        guest.guestUuid ?? '',
      );

      if (activeSession != null) {
        await _checkOut(activeSession);
      } else {
        await _checkIn(guest);
      }
    } catch (e) {
      emit(GuestSessionError('Terjadi kesalahan: $e'));
    }
  }

  Future<void> _checkIn(GuestsModel guest) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await _guestSessionLocalRepository.createSession(
      guestUuid: guest.guestUuid ?? '',
      eventUuid: guest.eventUuid,
    );

    emit(GuestCheckInSuccess(guest.copyWith(checkedInAt: DateTime.parse(now))));
  }

  /// ==============================
  /// CHECK-OUT
  /// ==============================
  Future<void> _checkOut(GuestSessionModel guest) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await _guestSessionLocalRepository.closeSession(guest.guestUuid);

    emit(GuestCheckOutSuccess(guest.copyWith(checkoutAt: DateTime.parse(now))));
  }
}
