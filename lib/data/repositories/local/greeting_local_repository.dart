import '../../../core/exception/custom_exception.dart';
import '../../../core/sync/sync_dispatcher.dart';
import '../../datasource/local/greeting_local_datasource.dart';
import '../../model/greeting_screen_model.dart';

abstract class GreetingLocalRepository {
  Future<void> insertGreetingScreen({required GreetingScreenModel greetingScreen});
  Future<void> updateGreetingScreen({required GreetingScreenModel greetingScreen});
  Future<void> deleteGreetingScreen({required String greetingUuid});
  Future<List<GreetingScreenModel>> getGreetingScreensByEventUuid({required String eventUuid});
}

class GreetingLocalRepositoryImpl implements GreetingLocalRepository {
  final GreetingLocalDatasource _greetingLocalDatasource;

  GreetingLocalRepositoryImpl(this._greetingLocalDatasource);

  factory GreetingLocalRepositoryImpl.create() {
    return GreetingLocalRepositoryImpl(GreetingLocalDatasource.create());
  }

  @override
  Future<void> insertGreetingScreen({required GreetingScreenModel greetingScreen}) async {
    try {
      await _greetingLocalDatasource.insertGreetingScreen(greetingScreen: greetingScreen);
      SyncDispatcher.onLocalChange();
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> updateGreetingScreen({required GreetingScreenModel greetingScreen}) async {
    try {
      await _greetingLocalDatasource.updateGreetingScreen(greetingScreen: greetingScreen);
      SyncDispatcher.onLocalChange();
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> deleteGreetingScreen({required String greetingUuid}) async {
    try {
      await _greetingLocalDatasource.deleteGreetingScreen(greetingUuid: greetingUuid);
      SyncDispatcher.onLocalChange();
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<List<GreetingScreenModel>> getGreetingScreensByEventUuid({
    required String eventUuid,
  }) async {
    try {
      return await _greetingLocalDatasource.getGreetingScreensByEventUuid(eventUuid: eventUuid);
    } catch (e) {
      return _dbError();
    }
  }
}

dynamic _dbError() => throw CustomException('Terjadi kesalahan database', code: -2);
