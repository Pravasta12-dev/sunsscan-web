part of 'guest_web_bloc.dart';

sealed class GuestWebState extends Equatable {
  const GuestWebState();

  @override
  List<Object> get props => [];
}

final class GuestWebInitial extends GuestWebState {}

final class GuestWebLoading extends GuestWebState {}

final class GuestWebLoaded extends GuestWebState {
  final List<GuestsModel> guests;

  const GuestWebLoaded({required this.guests});

  @override
  List<Object> get props => [guests];
}

final class GuestWebError extends GuestWebState {
  final String message;

  const GuestWebError({required this.message});

  @override
  List<Object> get props => [message];
}
