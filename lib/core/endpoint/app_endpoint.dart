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

  Uri get guestSessionsUrl {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/guest-sessions');
  }

  Uri get guestPhotoUrl {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/guest-photos');
  }

  Uri get uploadGuestPhotoUrl {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/guest-photos/upload');
  }

  Uri get guestCategoriesUrl {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/guest-categories');
  }

  Uri get souvenirsUrl {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/souvenirs');
  }

  Uri get greetingsUrl {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/greetings');
  }

  Uri fetchPublicEventByCode(String eventCode) {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/public/events/code/$eventCode');
  }

  Uri fetchPublicGuestByEventUuid(String eventUuid) {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/public/events/$eventUuid/guests');
  }

  Uri get syncPull {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/sync/pull');
  }

  Uri guestDelete(String guestUuid) {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/public/guests/$guestUuid');
  }

  Uri getGuestCategories(String eventUuid) {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/public/guest-categories/$eventUuid');
  }

  Uri get createGuestCategory {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/public/guest-categories');
  }

  Uri get createGuest {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/public/guests');
  }

  Uri updateGuest(String guestUuid) {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/public/guests/$guestUuid');
  }

  Uri getSouvenirByEventUuid(String eventUuid) {
    return UriHelper.createUrl(host: _baseUrl, path: 'api/public/souvenirs/$eventUuid');
  }

  factory AppEndpoint.create() {
    return AppEndpoint(baseUrl: Injection.baseUrl);
  }
}
