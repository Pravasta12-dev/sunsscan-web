part of 'event_bloc.dart';

sealed class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

final class EventInitial extends EventState {}

final class EventLoading extends EventState {}

final class EventLoaded extends EventState {
  const EventLoaded(this.events, {this.activeEvent});

  final List<EventModel> events;
  final EventModel? activeEvent;

  @override
  List<Object> get props => [events, activeEvent ?? ''];
}

final class EventError extends EventState {
  const EventError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
