part of 'greeting_bloc.dart';

sealed class GreetingState extends Equatable {
  const GreetingState();

  @override
  List<Object> get props => [];
}

final class GreetingInitial extends GreetingState {}

final class GreetingLoadInProgress extends GreetingState {}

final class GreetingLoadSuccess extends GreetingState {
  final List<GreetingScreenModel> greetingScreens;

  const GreetingLoadSuccess({required this.greetingScreens});

  @override
  List<Object> get props => [greetingScreens];
}

final class GreetingLoadFailure extends GreetingState {
  final String errorMessage;

  const GreetingLoadFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
