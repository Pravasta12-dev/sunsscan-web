import 'package:sun_scan/core/storage/database.dart';
import 'package:sun_scan/data/model/souvenir_model.dart';

class SouvenirLocalDataSource {
  final DatabaseHelper _databaseHelper;

  SouvenirLocalDataSource(this._databaseHelper);

  factory SouvenirLocalDataSource.create() {
    final databaseHelper = DatabaseHelper();
    return SouvenirLocalDataSource(databaseHelper);
  }

  Future<List<SouvenirModel>> getSouvenirByEvent(String eventUuid) async {
    final db = await _databaseHelper.database;

    try {
      final maps = await db.rawQuery(
        '''
          SELECT 
            souvenirs.*,
            guests.name AS guest_name,
            guest_categories.name AS guest_category_name,
            CASE 
              WHEN guests.checked_in_at IS NOT NULL THEN 1
              ELSE 0
            END AS checkin_status
          FROM souvenirs
          INNER JOIN guests ON souvenirs.guest_uuid = guests.guest_uuid
          INNER JOIN guest_categories ON souvenirs.guest_category_uuid = guest_categories.category_uuid
          WHERE souvenirs.event_uuid = ?
        ''',
        [eventUuid],
      );

      return maps.map((map) => SouvenirModel.fromJson(map)).toList();
    } catch (e) {
      throw Exception('Failed to get souvenirs by event: $e');
    }
  }

  Future<void> updateSouvenir(SouvenirModel souvenir) async {
    final db = await _databaseHelper.database;

    try {
      await db.update(
        'souvenirs',
        souvenir.toJson(),
        where: 'souvenir_uuid = ?',
        whereArgs: [souvenir.souvenirUuid],
      );
    } catch (e, st) {
      print('Error updating souvenir: $e');
      print(st);
      throw Exception('Failed to update souvenir: $e');
    }
  }
}
