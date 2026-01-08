import '../../../core/exception/custom_exception.dart';
import '../../datasource/local/guest_category_datasource.dart';
import '../../model/guest_category_model.dart';

abstract class GuestCategoryLocalRepository {
  Future<List<GuestCategoryModel>> fetchGuestCategories({
    required String eventUuid,
  });
}

class GuestCategoryLocalRepositoryImpl implements GuestCategoryLocalRepository {
  final GuestCategoryDatasource _datasource;

  GuestCategoryLocalRepositoryImpl({
    required GuestCategoryDatasource datasource,
  }) : _datasource = datasource;

  factory GuestCategoryLocalRepositoryImpl.create() {
    return GuestCategoryLocalRepositoryImpl(
      datasource: GuestCategoryDatasource.create(),
    );
  }

  @override
  Future<List<GuestCategoryModel>> fetchGuestCategories({
    required String eventUuid,
  }) async {
    try {
      return await _datasource.getAllCategories(eventUuid: eventUuid);
    } catch (e) {
      return _dbError();
    }
  }

  dynamic _dbError() => throw CustomException(
    'Terjadi kesalahan database',
    code: 'DATABASE_ERROR',
  );
}
