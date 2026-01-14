import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/data/model/greeting_screen_model.dart';
import 'package:sun_scan/data/model/guest_category_model.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/data/model/souvenir_model.dart';

class SyncPullResponse {
  final DateTime serverTime;
  final List<EventModel>? events;
  final List<GuestsModel>? guests;
  final List<GuestCategoryModel>? guestCategories;
  final List<SouvenirModel>? souvenirs;
  final List<GreetingScreenModel>? greetingScreens;

  SyncPullResponse({
    required this.serverTime,
    required this.events,
    required this.guests,
    required this.guestCategories,
    this.souvenirs,
    this.greetingScreens,
  });

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) {
    return SyncPullResponse(
      serverTime: DateTime.parse(json['server_time']),
      events: json['events'] != null
          ? (json['events'] as List<dynamic>)
                .map((e) => EventModel.fromJsonOnline(e)) // Pakai fromJsonOnline
                .toList()
          : null,
      guests: json['guests'] != null
          ? (json['guests'] as List<dynamic>).map((g) => GuestsModel.fromJsonOnline(g)).toList()
          : null,
      guestCategories: json['guest_categories'] != null
          ? (json['guest_categories'] as List<dynamic>)
                .map((c) => GuestCategoryModel.fromSyncJson(c))
                .toList()
          : null,
      souvenirs: json['souvenirs'] != null
          ? (json['souvenirs'] as List<dynamic>).map((s) => SouvenirModel.fromJson(s)).toList()
          : null,
      greetingScreens: json['greetings'] != null
          ? (json['greetings'] as List<dynamic>)
                .map((g) => GreetingScreenModel.fromJson(g, isOnline: true))
                .toList()
          : null,
    );
  }
}
