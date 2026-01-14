import '../../../core/exception/custom_exception.dart';
import '../../../core/sync/sync_dispatcher.dart';
import '../../datasource/local/souvenir_local_datasource.dart';
import '../../model/souvenir_model.dart';

abstract class SouvenirLocalRepository {
  Future<void> updateSouvenir(SouvenirModel souvenir);
  Future<List<SouvenirModel>> getSouvenirByEvent(String eventUuid);
}

class SouvenirLocalRepositoryImpl implements SouvenirLocalRepository {
  final SouvenirLocalDataSource _datasource;

  SouvenirLocalRepositoryImpl({required SouvenirLocalDataSource datasource})
    : _datasource = datasource;

  @override
  Future<List<SouvenirModel>> getSouvenirByEvent(String eventUuid) async {
    try {
      return await _datasource.getSouvenirByEvent(eventUuid);
    } catch (e) {
      return _dbError();
    }
  }

  @override
  Future<void> updateSouvenir(SouvenirModel souvenir) async {
    try {
      await _datasource.updateSouvenir(souvenir);
      SyncDispatcher.onLocalChange();
    } catch (e) {
      return _dbError();
    }
  }

  factory SouvenirLocalRepositoryImpl.create() {
    final datasource = SouvenirLocalDataSource.create();
    return SouvenirLocalRepositoryImpl(datasource: datasource);
  }
}

dynamic _dbError() => throw CustomException('Terjadi kesalahan database', code: -2);
