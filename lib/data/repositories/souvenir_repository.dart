import 'package:sun_scan/core/helper/platform_data_selector.dart';
import 'package:sun_scan/data/model/souvenir_model.dart';

import '../../core/exception/custom_exception.dart';
import '../datasource/remote/souvenir_remote_datasource.dart';
import 'local/souvenir_local_repository.dart';

abstract class SouvenirRepository {
  Future<List<SouvenirModel>> fetchSouvenirs({required String eventUuid});
}

class SouvenirRepositoryImpl implements SouvenirRepository {
  final PlatformDataSelector<SouvenirLocalRepository, SouvenirRemoteDatasource> _selector;

  factory SouvenirRepositoryImpl.create() {
    return SouvenirRepositoryImpl(
      selector: PlatformDataSelector(
        remoteDatasource: SouvenirRemoteDatasourceImpl.create(),
        localDatasource: SouvenirLocalRepositoryImpl.create(),
      ),
    );
  }

  SouvenirRepositoryImpl({
    required PlatformDataSelector<SouvenirLocalRepository, SouvenirRemoteDatasource> selector,
  }) : _selector = selector;

  @override
  Future<List<SouvenirModel>> fetchSouvenirs({required String eventUuid}) async {
    try {
      return await _selector.execute(
        webAction: (remote) => remote.fetchAll(eventUuid),
        localAction: (local) => local.getSouvenirByEvent(eventUuid),
      );
    } catch (e) {
      print('[SouvenirRepository] Error fetching souvenirs: $e');
      return _dbError();
    }
  }

  dynamic _dbError() => throw CustomException('Terjadi kesalahan database', code: 'DATABASE_ERROR');
}
