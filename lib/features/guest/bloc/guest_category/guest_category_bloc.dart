import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/repositories/local/guest_category_local_repository.dart';

import '../../../../data/model/guest_category_model.dart';

part 'guest_category_state.dart';

class GuestCategoryBloc extends Cubit<GuestCategoryState> {
  final GuestCategoryLocalRepository _guestCategoryLocalRepository =
      GuestCategoryLocalRepositoryImpl.create();

  GuestCategoryBloc() : super(const GuestCategoryState());

  Future<void> loadGuestCategories(String eventUuid) async {
    emit(state.copyWith(status: GuestCategoryStatus.loading));
    try {
      final categories = await _guestCategoryLocalRepository
          .fetchGuestCategories(eventUuid: eventUuid);
      emit(
        state.copyWith(
          categories: categories,
          status: GuestCategoryStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GuestCategoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
