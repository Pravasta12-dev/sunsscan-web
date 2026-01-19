import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/enum/enum.dart';

class GuestsModel extends Equatable {
  final String? guestUuid;
  final String eventUuid;
  final String name;
  final String? phone;
  final String qrValue;
  final Gender gender;
  final String? tag; // Tambahkan properti tag
  final String? guestCategoryUuid;
  final String? guestCategoryName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;
  final bool isDeleted;
  final DateTime? deletedAt;

  final String? eventName; // Tambahkan properti eventName
  final String? photoPath; // Tambahkan properti photoPath
  final String? photoUrl; // Tambahkan properti photoUrl
  final DateTime? lastCheckInAt; // Tambahkan properti lastCheckInAt
  final DateTime? lastCheckOutAt; // Tambahkan properti lastCheckOutAt

  const GuestsModel({
    this.guestUuid,
    required this.eventUuid,
    required this.name,
    this.phone,
    required this.qrValue,

    this.guestCategoryUuid,
    this.guestCategoryName,
    this.tag,
    this.gender = Gender.male,

    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.eventName,
    this.isDeleted = false,
    this.deletedAt,
    this.photoPath,
    this.photoUrl,
    this.lastCheckInAt,
    this.lastCheckOutAt,
  });

  @override
  List<Object?> get props => [
    guestUuid,
    eventUuid,
    name,
    phone,
    qrValue,
    guestCategoryUuid,
    guestCategoryName,
    tag,
    createdAt,
    updatedAt,
    syncStatus,
    gender,
    eventName,
    isDeleted,
    deletedAt,
    photoPath,
    photoUrl,
    lastCheckInAt,
    lastCheckOutAt,
  ];

  // tojson
  Map<String, dynamic> toJson() {
    return {
      'guest_uuid': guestUuid,
      'event_uuid': eventUuid,
      'name': name,
      'phone': phone,
      'qr_value': qrValue,
      'tag': tag,
      'guest_category_uuid': guestCategoryUuid,
      'guest_category_name': guestCategoryName,
      'gender': gender.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'sync_status': syncStatus.name,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // fromjson
  factory GuestsModel.fromJson(Map<String, dynamic> json) {
    return GuestsModel(
      guestUuid: json['guest_uuid'],
      eventUuid: json['event_uuid'],
      name: json['name'],
      phone: json['phone'],
      qrValue: json['qr_value'],
      tag: json['tag'],
      guestCategoryUuid: json['guest_category_uuid'],
      guestCategoryName: json['guest_category_name'],
      gender: Gender.values.firstWhere((e) => e.name == json['gender'], orElse: () => Gender.male),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
      isDeleted: json['is_deleted'] == 1,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      eventName: json['event_name'], // FIX: Added eventName from json
      photoPath: json['photo_path'], // FIX: Added photoPath from json
      photoUrl: json['photo_url'], // FIX: Added photoUrl from json
      lastCheckInAt: json['last_checkin_at'] != null
          ? DateTime.parse(json['last_checkin_at'])
          : null,
      lastCheckOutAt: json['last_checkout_at'] != null
          ? DateTime.parse(json['last_checkout_at'])
          : null,
    );
  }

  // copyWith
  GuestsModel copyWith({
    String? guestUuid,
    String? eventUuid,
    String? name,
    String? phone,
    String? qrValue,
    String? tag,
    String? guestCategoryUuid,
    String? guestCategoryName,
    Gender? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? eventName,
    bool? isDeleted,
    DateTime? deletedAt,
    String? photoPath,
    String? photoUrl,
    DateTime? lastCheckInAt,
    DateTime? lastCheckOutAt,
  }) {
    return GuestsModel(
      guestUuid: guestUuid ?? this.guestUuid,
      eventUuid: eventUuid ?? this.eventUuid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      qrValue: qrValue ?? this.qrValue,

      tag: tag ?? this.tag,
      guestCategoryUuid: guestCategoryUuid ?? this.guestCategoryUuid,
      guestCategoryName: guestCategoryName ?? this.guestCategoryName,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      eventName: eventName ?? this.eventName,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      photoPath: photoPath ?? this.photoPath,
      photoUrl: photoUrl ?? this.photoUrl,
      lastCheckInAt: lastCheckInAt ?? this.lastCheckInAt,
      lastCheckOutAt: lastCheckOutAt ?? this.lastCheckOutAt,
    );
  }

  Map<String, dynamic> toSyncJson() {
    return {
      'id': guestUuid,
      'event_id': eventUuid,
      'name': name,
      'phone': phone,
      'qr_value': qrValue,
      'tag': tag,
      'gender': gender.name,
      'guest_category_uuid': guestCategoryUuid,
      'guest_category_name': guestCategoryName,
      'created_at': createdAt.toUtc().toIso8601String(), // ✅ Convert ke string
      'updated_at': updatedAt?.toUtc().toIso8601String(), // ✅ Convert ke string
      'sync_status': syncStatus.name,
      'is_deleted': isDeleted,
      'deleted_at': deletedAt?.toUtc().toIso8601String(),
    };
  }

  factory GuestsModel.fromJsonOnline(Map<String, dynamic> json) {
    return GuestsModel(
      guestUuid: json['id'],
      eventUuid: json['event_id'],
      name: json['name'],
      phone: json['phone'],
      tag: json['tag'],
      qrValue: json['qr_value'],
      gender: Gender.values.firstWhere((e) => e.name == json['gender'], orElse: () => Gender.male),
      guestCategoryUuid: json['guest_category_uuid'],
      guestCategoryName: json['guest_category_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      syncStatus: json['sync_status'] != null
          ? SyncStatus.values.firstWhere(
              (e) => e.name == json['sync_status'],
              orElse: () => SyncStatus.synced,
            )
          : SyncStatus.synced,
      isDeleted: json['is_deleted'] == true,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      photoPath: json['photo_path'],
      photoUrl: json['photo_url'],
    );
  }
}
