import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/enum/enum.dart';

enum SouvenirStatus { pending, delivered, notYet }

class SouvenirModel extends Equatable {
  final String souvenirUuid;
  final String eventUuid;
  final String guestUuid;
  final String guestCategoryUuid;
  final SouvenirStatus status;
  final DateTime? receivedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;
  final bool isDeleted;
  final DateTime? deletedAt;

  // ==== HELPER ====
  final String? guestName;
  final String? guestCategoryName;
  final bool? checkinStatus;

  const SouvenirModel({
    required this.souvenirUuid,
    required this.eventUuid,
    required this.guestUuid,
    required this.guestCategoryUuid,
    required this.status,
    this.receivedAt,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.isDeleted = false,
    this.deletedAt,
    this.guestName,
    this.guestCategoryName,
    this.checkinStatus,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'souvenir_uuid': souvenirUuid,
      'event_uuid': eventUuid,
      'guest_uuid': guestUuid,
      'guest_category_uuid': guestCategoryUuid,
      'souvenir_status': status.name,
      'received_at': receivedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'sync_status': syncStatus.name,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // toOnlineJson
  Map<String, dynamic> toOnlineJson() {
    return {
      'souvenir_uuid': souvenirUuid,
      'event_uuid': eventUuid,
      'guest_uuid': guestUuid,
      'guest_category_uuid': guestCategoryUuid,
      'souvenir_status': status.name,
      'received_at': receivedAt?.toUtc().toIso8601String(),
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt?.toUtc().toIso8601String(),
      'is_deleted': isDeleted,
      'deleted_at': deletedAt?.toUtc().toIso8601String(),
    };
  }

  // fromJson
  factory SouvenirModel.fromJson(Map<String, dynamic> json) {
    return SouvenirModel(
      souvenirUuid: json['souvenir_uuid'],
      eventUuid: json['event_uuid'],
      guestUuid: json['guest_uuid'],
      guestCategoryUuid: json['guest_category_uuid'],
      status: SouvenirStatus.values.firstWhere(
        (e) => e.name == json['souvenir_status'],
        orElse: () => SouvenirStatus.pending,
      ),
      receivedAt: json['received_at'] != null ? DateTime.parse(json['received_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      syncStatus: json['sync_status'] != null
          ? SyncStatus.values.firstWhere(
              (e) => e.name == json['sync_status'],
              orElse: () => SyncStatus.pending,
            )
          : SyncStatus.pending,
      isDeleted: json['is_deleted'] == 1,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      guestName: json['guest_name'],
      guestCategoryName: json['guest_category_name'],
      checkinStatus: json['checkin_status'] == 1,
    );
  }

  @override
  List<Object?> get props => [
    souvenirUuid,
    eventUuid,
    guestUuid,
    guestCategoryUuid,
    status,
    receivedAt,
    createdAt,
    updatedAt,
    syncStatus,
    isDeleted,
    deletedAt,
    guestName,
    guestCategoryName,
    checkinStatus,
  ];

  //copyWith
  SouvenirModel copyWith({
    String? souvenirUuid,
    String? eventUuid,
    String? guestUuid,
    String? guestCategoryUuid,
    SouvenirStatus? status,
    DateTime? receivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    bool? isDeleted,
    DateTime? deletedAt,
    String? guestName,
    String? guestCategoryName,
    bool? checkinStatus,
  }) {
    return SouvenirModel(
      souvenirUuid: souvenirUuid ?? this.souvenirUuid,
      eventUuid: eventUuid ?? this.eventUuid,
      guestUuid: guestUuid ?? this.guestUuid,
      guestCategoryUuid: guestCategoryUuid ?? this.guestCategoryUuid,
      status: status ?? this.status,
      receivedAt: receivedAt ?? this.receivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      guestName: guestName ?? this.guestName,
      guestCategoryName: guestCategoryName ?? this.guestCategoryName,
      checkinStatus: checkinStatus ?? this.checkinStatus,
    );
  }
}
