import 'package:sqflite/sqflite.dart';
import 'package:sun_scan/core/enum/enum.dart';
import 'package:sun_scan/core/storage/database.dart';
import 'package:sun_scan/core/utils/code_generator.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/data/model/guest_category_model.dart';
import 'package:uuid/uuid.dart';

class EventLocalDatasource {
  final DatabaseHelper _databaseHelper;

  EventLocalDatasource(this._databaseHelper);

  static List<GuestCategoryModel> defaultGuestCategories(String eventUuid) {
    return [
      GuestCategoryModel(
        categoryUuid: Uuid().v4(),
        eventUuid: eventUuid,
        name: 'VIP',
        createdAt: DateTime.now(),
        syncStatus: SyncStatus.pending,
      ),
      GuestCategoryModel(
        categoryUuid: Uuid().v4(),
        eventUuid: eventUuid,
        name: 'Tamu Biasa',
        createdAt: DateTime.now(),
        syncStatus: SyncStatus.pending,
      ),
    ];
  }

  Future<int> insertEvent(EventModel event) async {
    final db = await _databaseHelper.database;
    try {
      final eventUuid = Uuid().v4();
      final eventCode = CodeGenerator.generateUniqueCode();
      final newEvent = event.copyWith(
        eventUuid: eventUuid,
        eventCode: eventCode,
        updatedAt: DateTime.now(),
        syncStatus: SyncStatus.pending,
      );
      await db.transaction((txn) async {
        await txn.insert('events', newEvent.toJson());

        // Insert default guest categories for the new event
        final defaultCategories = defaultGuestCategories(eventUuid);
        for (final category in defaultCategories) {
          await txn.insert('guest_categories', category.toJson());
        }
      });
      return 1; // Return success indicator
    } catch (e) {
      throw Exception('Failed to insert event: $e');
    }
  }

  Future<List<EventModel>> getAllEvents() async {
    final db = await _databaseHelper.database;
    try {
      final result = await db.query(
        'events',
        orderBy: 'event_date_start ASC',
        where: 'is_deleted = ?',
        whereArgs: [0],
      );
      return result.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get all events: $e');
    }
  }

  Future<int> updateEvent(EventModel event) async {
    final db = await _databaseHelper.database;
    try {
      print('[EventLocalDatasource] Updating event: ${event.eventUuid}');
      return await db.update(
        'events',
        event.copyWith(updatedAt: DateTime.now(), syncStatus: SyncStatus.pending).toJson(),
        where: 'event_uuid = ?',
        whereArgs: [event.eventUuid],
      );
    } catch (e, st) {
      print('[EventLocalDatasource] Error updating event: $e');
      print('[EventLocalDatasource] Stack trace: $st');
      throw Exception('Failed to update event: $e');
    }
  }

  Future<int> deleteEvent(String eventUuid) async {
    final db = await _databaseHelper.database;
    // Soft delete: tandai sebagai terhapus tanpa menghapus data secara fisik
    try {
      return await db.update(
        'events',
        {
          'is_deleted': 1,
          'deleted_at': DateTime.now().toUtc().toIso8601String(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
          'sync_status': SyncStatus.pending.name,
        },
        where: 'event_uuid = ?',
        whereArgs: [eventUuid],
      );
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<EventModel?> getActiveEvent() async {
    final db = await _databaseHelper.database;
    print('[EventLocalDatasource] Fetching active event from local database');
    try {
      final result = await db.query('events', where: 'is_active = ?', whereArgs: [1]);
      print('[EventLocalDatasource] Active event query result count: ${result.length}');
      if (result.isNotEmpty) {
        print('[EventLocalDatasource] Active event found: ${result.first}');
        return EventModel.fromJson(result.first);
      }
      return null;
    } catch (e) {
      print('[EventLocalDatasource] Error fetching active event: $e');
      throw Exception('Failed to get active event: $e');
    }
  }

  Future<void> setActiveEvent(String eventUuid) async {
    final db = await _databaseHelper.database;

    try {
      // Set all events to inactive
      await db.update('events', {'is_active': 0});

      // Set the specified event to active
      await db.update('events', {'is_active': 1}, where: 'event_uuid = ?', whereArgs: [eventUuid]);
    } catch (e) {
      throw Exception('Failed to set active event: $e');
    }
  }

  Future<List<EventModel>> getPendingSyncEvents(int limit) async {
    final db = await _databaseHelper.database;
    try {
      final result = await db.query(
        'events',
        where: 'sync_status = ?',
        whereArgs: [SyncStatus.pending.name],
        limit: limit,
      );
      return result.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get pending sync events: $e');
    }
  }

  Future<void> markEventsAsSynced(List<String> eventUuids) async {
    final db = await _databaseHelper.database;
    try {
      final ids = eventUuids.map((e) => '?').join(', ');
      await db.rawUpdate('UPDATE events SET sync_status = ? WHERE event_uuid IN ($ids)', [
        SyncStatus.synced.name,
        ...eventUuids,
      ]);
    } catch (e) {
      throw Exception('Failed to mark events as synced: $e');
    }
  }

  Future<void> upsertFromRemote(EventModel remote) async {
    final db = await _databaseHelper.database;

    final local = await db.query('events', where: 'event_uuid = ?', whereArgs: [remote.eventUuid]);

    if (local.isNotEmpty) {
      final localRow = local.first;

      final localSyncStatus = localRow['sync_status'] as String?;
      final localUpdatedAt = DateTime.tryParse(localRow['updated_at'] as String? ?? '');

      /// 1️⃣ JANGAN overwrite data lokal yang masih pending
      if (localSyncStatus == SyncStatus.pending.name) {
        return;
      }

      /// 2️⃣ JIKA REMOTE SUDAH DI-DELETE → HARUS TERAPKAN
      if (remote.isDeleted == true) {
        await db.delete('events', where: 'event_uuid = ?', whereArgs: [remote.eventUuid]);
        return;
      }

      /// 3️⃣ Bandingkan updated_at (normal case)
      if (localUpdatedAt != null &&
          remote.updatedAt != null &&
          localUpdatedAt.isAfter(remote.updatedAt!)) {
        return;
      }
    }

    /// 4️⃣ INSERT / REPLACE NORMAL
    await db.insert(
      'events',
      remote.copyWith(syncStatus: SyncStatus.synced).toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  factory EventLocalDatasource.create() {
    final databaseHelper = DatabaseHelper();
    return EventLocalDatasource(databaseHelper);
  }
}
