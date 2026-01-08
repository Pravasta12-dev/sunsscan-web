import 'package:sun_scan/core/sync/sync_config.dart';
import 'package:sun_scan/core/sync/sync_engine.dart';
import 'package:sun_scan/core/sync/sync_queue.dart';
import 'package:sun_scan/core/sync/sync_runner.dart';
import 'package:sun_scan/data/datasource/local/event_local_datasource.dart';
import 'package:sun_scan/data/datasource/local/guest_category_datasource.dart';
import 'package:sun_scan/data/datasource/local/guest_local_datasource.dart';
import 'package:sun_scan/data/datasource/remote/event_remote_datasource.dart';
import 'package:sun_scan/data/datasource/remote/guest_category_remote_datasource.dart';
import 'package:sun_scan/data/datasource/remote/guest_remote_datasource.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/data/model/guest_category_model.dart';
import 'package:sun_scan/data/model/guests_model.dart';

class SyncRegistry {
  static SyncEngine create({
    required EventLocalDatasource eventLocalDatasource,
    required EventRemoteDatasource eventRemoteDatasource,
    required GuestLocalDatasource guestLocalDatasource,
    required GuestRemoteDatasource guestRemoteDatasource,
    required GuestCategoryDatasource guestCategoryDatasource,
    required GuestCategoryRemoteDatasource guestCategoryRemoteDatasource,
  }) {
    final eventRunner = SyncRunner<EventModel>(
      queue: SyncQueue(
        fetchPending: eventLocalDatasource.getPendingSyncEvents,
        markAsSynced: eventLocalDatasource.markEventsAsSynced,
      ),
      remoteSync: eventRemoteDatasource.sync,
      getId: (event) => event.eventUuid ?? '',
    );

    final guestRunner = SyncRunner<GuestsModel>(
      queue: SyncQueue(
        fetchPending: guestLocalDatasource.getPendingSyncGuests,
        markAsSynced: guestLocalDatasource.markGuestsAsSynced,
      ),
      remoteSync: guestRemoteDatasource.sync,
      getId: (guest) => guest.guestUuid ?? '',
    );

    final guestCategoryRunner = SyncRunner<GuestCategoryModel>(
      queue: SyncQueue(
        fetchPending: guestCategoryDatasource.getPendingSyncGuestsCategories,
        markAsSynced: guestCategoryDatasource.markCategoriesAsSynced,
      ),
      remoteSync: guestCategoryRemoteDatasource.sync,
      getId: (category) => category.categoryUuid ?? '',
    );

    return SyncEngine(
      config: SyncConfig(interval: Duration(seconds: 8), batchSize: 20),
      runners: [eventRunner, guestRunner, guestCategoryRunner],
    );
  }
}
