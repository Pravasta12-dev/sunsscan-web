part of 'guest_session_bloc.dart';

sealed class GuestSessionState extends Equatable {
  const GuestSessionState();

  @override
  List<Object> get props => [];
}

final class GuestSessionInitial extends GuestSessionState {}

final class GuestSessionChecking extends GuestSessionState {}

final class GuestCheckInSuccess extends GuestSessionState {
  final GuestsModel session;

  const GuestCheckInSuccess(this.session);

  @override
  List<Object> get props => [session];
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
