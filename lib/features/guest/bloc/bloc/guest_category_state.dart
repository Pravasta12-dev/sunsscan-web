part of 'guest_category_bloc.dart';

enum GuestCategoryStatus { initial, loading, success, failure }

extension GuestCategoryStatusX on GuestCategoryStatus {
  bool get isInitial => this == GuestCategoryStatus.initial;
  bool get isLoading => this == GuestCategoryStatus.loading;
  bool get isSuccess => this == GuestCategoryStatus.success;
  bool get isFailure => this == GuestCategoryStatus.failure;
}

class GuestCategoryState extends Equatable {
  final List<GuestCategoryModel> categories;
  final GuestCategoryStatus status;
  final String? errorMessage;

  const GuestCategoryState({
    this.categories = const [],
    this.status = GuestCategoryStatus.initial,
    this.errorMessage,
  });

  GuestCategoryState copyWith({
    List<GuestCategoryModel>? categories,
    GuestCategoryStatus? status,
    String? errorMessage,
  }) {
    return GuestCategoryState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [categories, status, errorMessage];
}
