part of 'souvenir_bloc.dart';

sealed class SouvenirState extends Equatable {
  const SouvenirState();

  @override
  List<Object> get props => [];
}

final class SouvenirInitial extends SouvenirState {}

final class SouvenirLoading extends SouvenirState {}

final class SouvenirLoaded extends SouvenirState {
  final List<SouvenirModel> souvenirs;

  const SouvenirLoaded({required this.souvenirs});

  @override
  List<Object> get props => [souvenirs];
}

final class SouvenirError extends SouvenirState {
  final String message;

  const SouvenirError({required this.message});

  @override
  List<Object> get props => [message];
}
