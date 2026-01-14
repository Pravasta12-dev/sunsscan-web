import 'package:sun_scan/core/helper/platform_data_selector.dart';
import 'package:sun_scan/data/datasource/remote/guest_category_remote_datasource.dart';

import '../../core/exception/custom_exception.dart';
import '../datasource/local/guest_category_datasource.dart';
import '../model/guest_category_model.dart';

abstract class GuestCategoryRepository {
  Future<List<GuestCategoryModel>> fetchGuestCategories({required String eventUuid});
}

class GuestCategoryRepositoryImpl implements GuestCategoryRepository {
  final PlatformDataSelector<GuestCategoryDatasource, GuestCategoryRemoteDatasource> _selector;

  GuestCategoryRepositoryImpl({
    required PlatformDataSelector<GuestCategoryDatasource, GuestCategoryRemoteDatasource> selector,
  }) : _selector = selector;

  factory GuestCategoryRepositoryImpl.create() {
    return GuestCategoryRepositoryImpl(
      selector: PlatformDataSelector(
        localDatasource: GuestCategoryDatasource.create(),
        remoteDatasource: GuestCategoryRemoteDatasourceImpl.create(),
      ),
    );
  }

  @override
  Future<List<GuestCategoryModel>> fetchGuestCategories({required String eventUuid}) async {
    try {
      return await _selector.execute(
        webAction: (remote) => remote.fetchCategoriesByEventId(eventUuid),
        localAction: (local) => local.getAllCategories(eventUuid: eventUuid),
      );
    } catch (e) {
      print('[GuestCategoryRepository] Error fetching guest categories: $e');
      return _dbError();
    }
  }
}

dynamic _dbError() => throw CustomException('Terjadi kesalahan database', code: -2);
