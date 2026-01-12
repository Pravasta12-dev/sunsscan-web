import 'package:sun_scan/core/storage/database.dart';
import 'package:sun_scan/data/model/greeting_screen_model.dart';
import 'package:uuid/uuid.dart';

class GreetingLocalDatasource {
  final DatabaseHelper _databaseHelper;

  GreetingLocalDatasource(this._databaseHelper);

  factory GreetingLocalDatasource.create() {
    return GreetingLocalDatasource(DatabaseHelper());
  }

  Future<void> insertGreetingScreen({required GreetingScreenModel greetingScreen}) async {
    final db = await _databaseHelper.database;

    try {
      final greetingUuid = Uuid().v4();

      await db.insert(
        'greeting_screens',
        greetingScreen.copyWith(greetingUuid: greetingUuid).toJson(),
      );
    } catch (e) {
      print('Error inserting greeting screen: $e');
      throw Exception('Failed to insert greeting screen');
    }
  }

  Future<void> updateGreetingScreen({required GreetingScreenModel greetingScreen}) async {
    final db = await _databaseHelper.database;

    try {
      await db.update(
        'greeting_screens',
        greetingScreen.toJson(),
        where: 'greeting_uuid = ?',
        whereArgs: [greetingScreen.greetingUuid],
      );
    } catch (e) {
      print('Error updating greeting screen: $e');
      throw Exception('Failed to update greeting screen');
    }
  }

  Future<void> deleteGreetingScreen({required String greetingUuid}) async {
    final db = await _databaseHelper.database;

    try {
      await db.delete('greeting_screens', where: 'greeting_uuid = ?', whereArgs: [greetingUuid]);
    } catch (e) {
      print('Error deleting greeting screen: $e');
      throw Exception('Failed to delete greeting screen');
    }
  }

  Future<List<GreetingScreenModel>> getGreetingScreensByEventUuid({
    required String eventUuid,
  }) async {
    final db = await _databaseHelper.database;

    try {
      final maps = await db.query(
        'greeting_screens',
        where: 'event_uuid = ?',
        whereArgs: [eventUuid],
      );

      return List.generate(maps.length, (i) {
        return GreetingScreenModel.fromJson(maps[i]);
      });
    } catch (e) {
      print('Error fetching greeting screens: $e');
      throw Exception('Failed to fetch greeting screens');
    }
  }
}
