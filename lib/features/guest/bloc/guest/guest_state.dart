part of 'guest_bloc.dart';

sealed class GuestState extends Equatable {
  const GuestState();

  @override
  List<Object> get props => [];
}

final class GuestInitial extends GuestState {}

final class GuestLoading extends GuestState {}

final class GuestLoaded extends GuestState {
  final List<GuestsModel> guests;

  const GuestLoaded(this.guests);

  @override
  List<Object> get props => [guests];
}

final class GuestError extends GuestState {
  final String message;

  const GuestError(this.message);

  @override
  List<Object> get props => [message];
}

final class GuestScanLoading extends GuestState {}

final class GuestScanSuccess extends GuestState {
  final GuestsModel guest;
  final DateTime timestamp; // Unique per scan event

  GuestScanSuccess(this.guest) : timestamp = DateTime.now();

  @override
  List<Object> get props => [guest, timestamp]; // Include timestamp in props
}

final class GuestScanFailure extends GuestState {
  final String message;
  final DateTime timestamp; // Unique per scan event

  GuestScanFailure(this.message) : timestamp = DateTime.now();

  @override
  List<Object> get props => [message, timestamp]; // Include timestamp in props
}

final class GuestsImportLoading extends GuestState {}

final class GuestsImportSuccess extends GuestState {
  final int importedCount;

  const GuestsImportSuccess(this.importedCount);

  @override
  List<Object> get props => [importedCount];
}

final class GuestsImportFailure extends GuestState {
  final String message;

  const GuestsImportFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class GuestsImportProgress extends GuestState {
  final int current;
  final int total;

  const GuestsImportProgress(this.current, this.total);

  @override
  List<Object> get props => [current, total];
}
