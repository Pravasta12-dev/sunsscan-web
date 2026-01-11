import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sun_scan/data/repositories/local/souvenir_local_repository.dart';

import '../../../../data/model/souvenir_model.dart';

part 'souvenir_state.dart';

class SouvenirBloc extends Cubit<SouvenirState> {
  final SouvenirLocalRepository _souvenirLocalRepository =
      SouvenirLocalRepositoryImpl.create();

  SouvenirBloc() : super(SouvenirInitial());

  Future<void> loadSouvenirs(String eventUuid) async {
    emit(SouvenirLoading());
    try {
      final souvenirs = await _souvenirLocalRepository.getSouvenirByEvent(
        eventUuid,
      );
      emit(SouvenirLoaded(souvenirs: souvenirs));
    } catch (e) {
      emit(SouvenirError(message: e.toString()));
    }
  }

  Future<void> updateSouvenir(SouvenirModel souvenir) async {
    try {
      await _souvenirLocalRepository.updateSouvenir(souvenir);
      final currentState = state;
      if (currentState is SouvenirLoaded) {
        final updatedSouvenirs = currentState.souvenirs.map((s) {
          return s.souvenirUuid == souvenir.souvenirUuid ? souvenir : s;
        }).toList();
        emit(SouvenirLoaded(souvenirs: updatedSouvenirs));
      }
    } catch (e) {
      emit(SouvenirError(message: e.toString()));
    }
  }
}
