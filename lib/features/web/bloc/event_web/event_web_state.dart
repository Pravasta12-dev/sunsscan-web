part of 'event_web_bloc.dart';

sealed class EventWebState extends Equatable {
  const EventWebState();

  @override
  List<Object> get props => [];
}

final class EventWebInitial extends EventWebState {}

final class EventWebLoading extends EventWebState {}

final class EventWebLoaded extends EventWebState {
  final EventModel event;

  const EventWebLoaded({required this.event});

  @override
  List<Object> get props => [event];
}

final class EventWebError extends EventWebState {
  final String message;

  const EventWebError({required this.message});

  @override
  List<Object> get props => [message];
}
