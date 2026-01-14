import 'package:sun_scan/core/exception/app_exception.dart';
import 'package:sun_scan/core/exception/network_exception.dart';
import 'package:sun_scan/core/helper/platform_data_selector.dart';
import 'package:sun_scan/core/network/result.dart';
import 'package:sun_scan/data/model/souvenir_model.dart';

import '../datasource/remote/souvenir_remote_datasource.dart';
import 'local/souvenir_local_repository.dart';

abstract class SouvenirRepository {
  Future<Result<List<SouvenirModel>>> fetchSouvenirs({required String eventUuid});
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
  Future<Result<List<SouvenirModel>>> fetchSouvenirs({required String eventUuid}) async {
    try {
      final data = await _selector.execute(
        webAction: (remote) => remote.fetchAll(eventUuid),
        localAction: (local) => local.getSouvenirByEvent(eventUuid),
      );

      return Result.success(data);
    } on NoInternetException {
      return Result.noInternet();
    } on AppException catch (e) {
      return Result.error(e.message, code: e.code ?? -1, message: e.message);
    } catch (e) {
      return Result.error(e.toString(), message: 'Terjadi kesalahan tidak diketahui');
    }
  }
}
