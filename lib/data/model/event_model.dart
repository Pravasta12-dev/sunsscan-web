import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/enum/enum.dart';

class EventModel extends Equatable {
  final String? eventUuid;
  final String? eventCode;
  final String name;
  final DateTime eventDateStart;
  final DateTime eventDateEnd;
  final String? location;
  final bool isActive;
  final bool outActive;
  final bool isLocked;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;

  const EventModel({
    this.eventUuid,
    this.eventCode,
    required this.name,
    required this.eventDateStart,
    required this.eventDateEnd,
    this.location,
    required this.isActive,
    this.outActive = false,
    this.isLocked = false,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.pending,
  });

  @override
  List<Object?> get props => [
    eventUuid,
    eventCode,
    name,
    eventDateStart,
    eventDateEnd,
    location,
    isActive,
    outActive,
    isLocked,
    createdAt,
    updatedAt,
    syncStatus,
  ];

  Map<String, dynamic> toJson() {
    return {
      'event_uuid': eventUuid,
      'event_code': eventCode,
      'name': name,
      'event_date_start': eventDateStart.toIso8601String(),
      'event_date_end': eventDateEnd.toIso8601String(),
      'location': location,
      'is_active': isActive ? 1 : 0,
      'out_active': outActive ? 1 : 0,
      'is_locked': isLocked ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'sync_status': syncStatus.name,
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventUuid: json['event_uuid'],
      name: json['name'],
      eventCode: json['event_code'],
      eventDateStart: DateTime.parse(json['event_date_start']),
      eventDateEnd: DateTime.parse(json['event_date_end']),
      location: json['location'],
      isActive: json['is_active'] == 1,
      outActive: json['out_active'] == 1,
      isLocked: json['is_locked'] == 1,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
    );
  }

  /// Parse dari response server (format berbeda dari DB lokal)
  factory EventModel.fromJsonOnline(Map<String, dynamic> json) {
    return EventModel(
      eventUuid: json['id'], // Server pakai 'id'
      name: json['name'] ?? '',
      eventCode: json['event_code'],
      eventDateStart: DateTime.parse(json['event_date_start']),
      eventDateEnd: DateTime.parse(json['event_date_end']),
      location: json['location'],
      isActive: json['is_active'] == true, // Boolean native
      outActive: json['out_active'] == true,
      isLocked: json['is_locked'] == true,
      createdAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      syncStatus: json['SyncStatus'] != null
          ? SyncStatus.values.firstWhere(
              (e) => e.name.toLowerCase() == (json['SyncStatus'] as String).toLowerCase(),
              orElse: () => SyncStatus.synced,
            )
          : SyncStatus.synced,
    );
  }

  factory EventModel.empty() {
    return EventModel(
      eventUuid: null,
      eventCode: null,
      name: '',
      eventDateStart: DateTime.now(),
      eventDateEnd: DateTime.now(),
      location: null,
      isActive: false,
      outActive: false,
      isLocked: false,
      createdAt: DateTime.now(),
      updatedAt: null,
      syncStatus: SyncStatus.pending,
    );
  }

  static bool isEventLocked(EventModel? event) {
    if (event == null) return false;
    return event.isLocked;
  }

  EventModel copyWith({
    String? eventUuid,
    String? eventCode,
    String? name,
    DateTime? eventDateStart,
    DateTime? eventDateEnd,
    String? location,
    bool? isActive,
    bool? outActive,
    bool? isLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return EventModel(
      eventUuid: eventUuid ?? this.eventUuid,
      eventCode: eventCode ?? this.eventCode,
      name: name ?? this.name,
      eventDateStart: eventDateStart ?? this.eventDateStart,
      eventDateEnd: eventDateEnd ?? this.eventDateEnd,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      outActive: outActive ?? this.outActive,
      isLocked: isLocked ?? this.isLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toSyncJson() {
    return {
      'id': eventUuid,
      'event_code': eventCode,
      'name': name,
      'event_date_start': eventDateStart.toUtc().toIso8601String(),
      'event_date_end': eventDateEnd.toUtc().toIso8601String(),
      'location': location,
      'is_active': isActive,
      'out_active': outActive,
      'is_locked': isLocked,
      'updated_at': updatedAt?.toUtc().toIso8601String(),
    };
  }
}
