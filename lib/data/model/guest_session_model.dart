import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/enum/enum.dart';

class GuestSessionModel extends Equatable {
  final String sessionUuid;
  final String guestUuid;
  final String eventUuid;

  final DateTime checkinAt;
  final DateTime? checkoutAt;

  final SyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;

  final bool isDeleted;
  final DateTime? deletedAt;

  const GuestSessionModel({
    required this.sessionUuid,
    required this.guestUuid,
    required this.eventUuid,
    required this.checkinAt,
    this.checkoutAt,
    this.syncStatus = SyncStatus.pending,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    sessionUuid,
    guestUuid,
    eventUuid,
    checkinAt,
    checkoutAt,
    syncStatus,
    createdAt,
    updatedAt,
    isDeleted,
    deletedAt,
  ];

  factory GuestSessionModel.fromJson(Map<String, dynamic> json, {bool fromOnline = false}) {
    return GuestSessionModel(
      sessionUuid: json['session_uuid'],
      guestUuid: json['guest_uuid'],
      eventUuid: json['event_uuid'],
      checkinAt: DateTime.parse(json['checkin_at']),
      checkoutAt: json['checkout_at'] != null ? DateTime.parse(json['checkout_at']) : null,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      isDeleted: fromOnline == true ? (json['is_deleted'] == true) : (json['is_deleted'] == 1),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson({bool forOnline = false}) {
    return {
      'session_uuid': sessionUuid,
      'guest_uuid': guestUuid,
      'event_uuid': eventUuid,
      'checkin_at': checkinAt.toIso8601String(),
      'checkout_at': checkoutAt?.toIso8601String(),
      'sync_status': syncStatus.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': forOnline ? isDeleted : (isDeleted ? 1 : 0),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // copyWith
  GuestSessionModel copyWith({
    String? sessionUuid,
    String? guestUuid,
    String? eventUuid,
    DateTime? checkinAt,
    DateTime? checkoutAt,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return GuestSessionModel(
      sessionUuid: sessionUuid ?? this.sessionUuid,
      guestUuid: guestUuid ?? this.guestUuid,
      eventUuid: eventUuid ?? this.eventUuid,
      checkinAt: checkinAt ?? this.checkinAt,
      checkoutAt: checkoutAt ?? this.checkoutAt,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  // empty
  factory GuestSessionModel.empty() {
    return GuestSessionModel(
      sessionUuid: '',
      guestUuid: '',
      eventUuid: '',
      checkinAt: DateTime.fromMillisecondsSinceEpoch(0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
