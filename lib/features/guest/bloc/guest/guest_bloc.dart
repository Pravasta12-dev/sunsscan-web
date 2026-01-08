import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/helper/csv_import_helper.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/data/repositories/local/guest_local_repository.dart';
import 'package:uuid/uuid.dart';

part 'guest_state.dart';

class GuestBloc extends Cubit<GuestState> {
  GuestBloc() : super(GuestInitial());

  final GuestLocalRepositoryImpl _guestLocalRepository =
      GuestLocalRepositoryImpl.create();

  Future<void> loadGuests(String eventUuid) async {
    emit(GuestLoading());
    try {
      final guests = await _guestLocalRepository.getGuestsByEventId(eventUuid);
      emit(GuestLoaded(guests));
    } catch (e) {
      emit(GuestError(e.toString()));
    }
  }

  Future<void> addGuest(GuestsModel guest) async {
    try {
      await _guestLocalRepository.insertGuest(guest);
      // Reload guests after adding
      await loadGuests(guest.eventUuid);
    } catch (e) {
      emit(GuestError(e.toString()));
    }
  }

  Future<void> importGuests(String eventUuid, String filePath) async {
    try {
      final rows = await CsvImportHelper.parseFromPath(filePath);
      if (rows.isEmpty) {
        emit(const GuestsImportFailure('File kosong'));
        return;
      }

      final guests = rows.where((r) => r['name']!.trim().isNotEmpty).map((row) {
        final qrValue = const Uuid().v4();

        final qrData = 'SUNSCAN|$eventUuid|$qrValue';
        return GuestsModel(
          eventUuid: eventUuid,
          name: row['name']!.trim(),
          phone: row['phone']?.trim().isEmpty == true ? null : row['phone'],
          qrValue: qrData,
          isCheckedIn: false,
          photo: null,
          createdAt: DateTime.now(),
        );
      }).toList();

      await _guestLocalRepository.insertGuestsBatch(
        guests: guests,
        onProgress: (current, total) {
          emit(GuestsImportProgress(current, total));
        },
      );
      emit(GuestsImportSuccess(guests.length));
    } catch (e) {
      emit(GuestsImportFailure(e.toString()));
    }
  }

  Future<void> updateGuest(GuestsModel guest) async {
    try {
      await _guestLocalRepository.updateGuest(guest);
      // Reload guests after updating
      await loadGuests(guest.eventUuid);
    } catch (e) {
      emit(GuestError(e.toString()));
    }
  }

  Future<void> deleteGuest(String guestUuid, String eventUuid) async {
    try {
      await _guestLocalRepository.deleteGuest(guestUuid);
      // Reload guests after deleting
      await loadGuests(eventUuid);
    } catch (e) {
      emit(GuestError(e.toString()));
    }
  }

  Future<void> scanCheckIn(String qrValue) async {
    try {
      final guest = await _guestLocalRepository.getGuestByQrValue(qrValue);
      if (guest == null) {
        emit(GuestScanFailure('Tamu tidak ditemukan'));
        return;
      }

      // Jika sudah check-in
      if (guest.isCheckedIn) {
        emit(GuestScanFailure('Tamu sudah check-in sebelumnya'));
        return;
      }

      // Jika sudah pernah checkout
      if (guest.checkedOutAt != null) {
        emit(GuestScanFailure('Tamu sudah checkout sebelumnya'));
        return;
      }

      // Check-in process
      final checkInTime = DateTime.now().toIso8601String();
      await _guestLocalRepository.checkInGuest(guest.eventUuid, checkInTime);
      emit(
        GuestScanSuccess(
          guest.copyWith(isCheckedIn: true, checkedInAt: DateTime.now()),
        ),
      );
    } catch (e) {
      emit(GuestScanFailure(e.toString()));
    }
  }

  Future<void> scanCheckOut(String qrValue) async {
    try {
      final guest = await _guestLocalRepository.getGuestByQrValue(qrValue);
      if (guest == null) {
        emit(GuestScanFailure('Tamu tidak ditemukan'));
        return;
      }

      // Jika belum check-in
      if (!guest.isCheckedIn) {
        emit(GuestScanFailure('Tamu belum check-in'));
        return;
      }

      // Jika sudah pernah checkout
      if (guest.checkedOutAt != null) {
        emit(GuestScanFailure('Tamu sudah checkout sebelumnya'));
        return;
      }

      // Check-out process
      final checkOutTime = DateTime.now().toIso8601String();
      await _guestLocalRepository.checkOutGuest(guest.eventUuid, checkOutTime);
      emit(
        GuestScanSuccess(
          guest.copyWith(isCheckedIn: false, checkedOutAt: DateTime.now()),
        ),
      );
    } catch (e) {
      emit(GuestScanFailure(e.toString()));
    }
  }

  Future<void> scanGuest(String qrValue) async {
    try {
      final guest = await _guestLocalRepository.getGuestByQrValue(qrValue);
      if (guest == null) {
        emit(GuestScanFailure('Tamu tidak ditemukan'));
        return;
      }

      // Jika sudah pernah checkout, tidak bisa scan lagi
      if (guest.checkedOutAt != null) {
        emit(GuestScanFailure('Tamu sudah checkout sebelumnya'));
        return;
      }

      if (guest.isCheckedIn) {
        // Check-out process
        final checkOutTime = DateTime.now().toIso8601String();
        await _guestLocalRepository.checkOutGuest(
          guest.eventUuid,
          checkOutTime,
        );
        emit(
          GuestScanSuccess(
            guest.copyWith(isCheckedIn: false, checkedOutAt: DateTime.now()),
          ),
        );
        return;
      }

      // Check-in process
      final checkInTime = DateTime.now().toIso8601String();
      await _guestLocalRepository.checkInGuest(guest.eventUuid, checkInTime);
      emit(
        GuestScanSuccess(
          guest.copyWith(isCheckedIn: true, checkedInAt: DateTime.now()),
        ),
      );
    } catch (e) {
      emit(GuestScanFailure(e.toString()));
    }
  }
}
