import '../injection/injection.dart';
import 'uri_helper.dart';

class AppEndpoint {
  final String _baseUrl;

  AppEndpoint({required String baseUrl}) : _baseUrl = baseUrl;

  Uri get eventsUrl {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/events');
  }

  Uri get guestsUrl {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/guests');
  }

  Uri get guestCategoriesUrl {
    return UriHelper.createUrl(
      host: _baseUrl,
      path: 'api/sync/guest-categories',
    );
  }

  Uri fetchPublicEventByCode(String eventCode) {
    return UriHelper.createUrl(
      host: _baseUrl,
      path: 'api/public/events/code/$eventCode',
    );
  }

  Uri fetchPublicGuestByEventUuid(String eventUuid) {
    return UriHelper.createUrl(
      host: _baseUrl,
      path: 'api/public/events/$eventUuid/guests',
    );
  }

  Uri get syncPull {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/pull');
  }

  factory AppEndpoint.create() {
    return AppEndpoint(baseUrl: Injection.baseUrl);
  }
}
