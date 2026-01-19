part of 'guest_session_bloc.dart';

sealed class GuestSessionState extends Equatable {
  const GuestSessionState();

  @override
  List<Object> get props => [];
}

final class GuestSessionInitial extends GuestSessionState {}

final class GuestSessionChecking extends GuestSessionState {}

final class GuestCheckInSuccess extends GuestSessionState {
  final GuestsModel guest;
  final GuestSessionModel session;

  const GuestCheckInSuccess(this.guest, this.session);

  @override
  List<Object> get props => [guest, session];
}

final class GuestCheckOutSuccess extends GuestSessionState {
  final GuestSessionModel session;

  const GuestCheckOutSuccess(this.session);

  @override
  List<Object> get props => [session];
}

final class GuestSessionError extends GuestSessionState {
  final String message;

  const GuestSessionError(this.message);

  @override
  List<Object> get props => [message];
}

final class GuestSessionLoading extends GuestSessionState {}

final class GuestSessionLoaded extends GuestSessionState {
  final List<GuestActivityModel> activities;

  const GuestSessionLoaded(this.activities);

  @override
  List<Object> get props => [activities];
}

final class GuestSessionLoadError extends GuestSessionState {
  final String message;

  const GuestSessionLoadError(this.message);

  @override
  List<Object> get props => [message];
}
