import 'package:sun_scan/core/sync/sync_config.dart';
import 'package:sun_scan/core/sync/sync_engine.dart';
import 'package:sun_scan/core/sync/sync_queue.dart';
import 'package:sun_scan/core/sync/sync_runner.dart';
import 'package:sun_scan/data/datasource/local/event_local_datasource.dart';
import 'package:sun_scan/data/datasource/local/guest_category_datasource.dart';
import 'package:sun_scan/data/datasource/local/guest_local_datasource.dart';
import 'package:sun_scan/data/datasource/local/guest_session_local_datasource.dart';
import 'package:sun_scan/data/datasource/local/souvenir_local_datasource.dart';
import 'package:sun_scan/data/datasource/remote/event_remote_datasource.dart';
import 'package:sun_scan/data/datasource/remote/guest_category_remote_datasource.dart';
import 'package:sun_scan/data/datasource/remote/guest_remote_datasource.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/data/model/greeting_screen_model.dart';
import 'package:sun_scan/data/model/guest_category_model.dart';
import 'package:sun_scan/data/model/guest_session_model.dart';
import 'package:sun_scan/data/model/guests_model.dart';

import '../../data/datasource/local/greeting_local_datasource.dart';
import '../../data/datasource/remote/greeting_remote_datasource.dart';
import '../../data/datasource/remote/guest_session_remote_datasource.dart';
import '../../data/datasource/remote/souvenir_remote_datasource.dart';
import '../../data/model/souvenir_model.dart';

class SyncRegistry {
  static SyncEngine create({
    required EventLocalDatasource eventLocalDatasource,
    required EventRemoteDatasource eventRemoteDatasource,
    required GuestLocalDatasource guestLocalDatasource,
    required GuestRemoteDatasource guestRemoteDatasource,
    required GuestCategoryDatasource guestCategoryDatasource,
    required GuestCategoryRemoteDatasource guestCategoryRemoteDatasource,
    required SouvenirLocalDataSource souvenirLocalDatasource,
    required SouvenirRemoteDatasource souvenirRemoteDatasource,
    required GreetingLocalDatasource greetingLocalDatasource,
    required GreetingRemoteDatasource greetingRemoteDatasource,
    required GuestSessionLocalDatasource guestSessionLocalDatasource,
    required GuestSessionRemoteDatasource guestSessionRemoteDatasource,
  }) {
    final eventRunner = SyncRunner<EventModel>(
      queue: SyncQueue(
        fetchPending: eventLocalDatasource.getPendingSyncEvents,
        markAsSynced: eventLocalDatasource.markEventsAsSynced,
      ),
      pushRemote: eventRemoteDatasource.sync,
      getId: (event) => event.eventUuid ?? '',
    );

    final guestCategoryRunner = SyncRunner<GuestCategoryModel>(
      queue: SyncQueue(
        fetchPending: guestCategoryDatasource.getPendingSyncGuestsCategories,
        markAsSynced: guestCategoryDatasource.markCategoriesAsSynced,
      ),
      pushRemote: guestCategoryRemoteDatasource.sync,
      getId: (category) => category.categoryUuid ?? '',
    );

    final guestRunner = SyncRunner<GuestsModel>(
      queue: SyncQueue(
        fetchPending: guestLocalDatasource.getPendingSyncGuests,
        markAsSynced: guestLocalDatasource.markGuestsAsSynced,
      ),
      pushRemote: guestRemoteDatasource.sync,
      getId: (guest) => guest.guestUuid ?? '',
    );

    final souvenirRunner = SyncRunner<SouvenirModel>(
      queue: SyncQueue(
        fetchPending: souvenirLocalDatasource.getPendingSyncSouvenirs,
        markAsSynced: souvenirLocalDatasource.markSouvenirsAsSynced,
      ),
      pushRemote: souvenirRemoteDatasource.sync,
      getId: (souvenir) => souvenir.souvenirUuid,
    );

    final greetingRunner = SyncRunner<GreetingScreenModel>(
      queue: SyncQueue(
        fetchPending: greetingLocalDatasource.getPendingGreetingScreens,
        markAsSynced: greetingLocalDatasource.markGreetingScreensAsSynced,
      ),
      pushRemote: greetingRemoteDatasource.sync,
      getId: (greeting) => greeting.greetingUuid ?? '',
    );

    final guestSessionRunner = SyncRunner<GuestSessionModel>(
      queue: SyncQueue(
        fetchPending: guestSessionLocalDatasource.getPendingSessions,
        markAsSynced: guestSessionLocalDatasource.markSessionsAsSynced,
      ),
      pushRemote: guestSessionRemoteDatasource.sync,
      getId: (session) => session.sessionUuid,
    );

    return SyncEngine(
      config: SyncConfig(interval: Duration(seconds: 8), batchSize: 20),
      runners: [
        eventRunner,
        guestCategoryRunner,
        guestRunner,
        souvenirRunner,
        greetingRunner,
        guestSessionRunner,
      ],
    );
  }
}
