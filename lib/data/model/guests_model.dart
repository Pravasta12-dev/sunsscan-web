import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/enum/enum.dart';

class GuestsModel extends Equatable {
  final String? guestUuid;
  final String eventUuid;
  final String name;
  final String? phone;
  final String qrValue;
  final bool isCheckedIn;
  final Gender gender;
  final String? tag; // Tambahkan properti tag
  final String? guestCategoryUuid;
  final String? guestCategoryName;
  final DateTime? checkedInAt;
  final DateTime? checkedOutAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;
  final bool isDeleted;
  final DateTime? deletedAt;

  final String? eventName; // Tambahkan properti eventName
  final String? photoPath; // Tambahkan properti photoPath
  final String? photoUrl; // Tambahkan properti photoUrl

  const GuestsModel({
    this.guestUuid,
    required this.eventUuid,
    required this.name,
    this.phone,
    required this.qrValue,
    required this.isCheckedIn,
    this.guestCategoryUuid,
    this.guestCategoryName,
    this.tag,
    this.gender = Gender.male,
    this.checkedInAt,
    this.checkedOutAt,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.eventName,
    this.isDeleted = false,
    this.deletedAt,
    this.photoPath,
    this.photoUrl,
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
    isCheckedIn,

    checkedInAt,
    checkedOutAt,
    createdAt,
    updatedAt,
    syncStatus,
    gender,
    eventName,
    isDeleted,
    deletedAt,
    photoPath,
    photoUrl,
  ];

  // tojson
  Map<String, dynamic> toJson() {
    return {
      'guest_uuid': guestUuid,
      'event_uuid': eventUuid,
      'name': name,
      'phone': phone,
      'qr_value': qrValue,
      'is_checked_in': isCheckedIn ? 1 : 0,
      'tag': tag,
      'guest_category_uuid': guestCategoryUuid,
      'guest_category_name': guestCategoryName,
      'gender': gender.name,

      'checked_in_at': checkedInAt?.toIso8601String(),
      'checked_out_at': checkedOutAt?.toIso8601String(),
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
      isCheckedIn: json['is_checked_in'] == 1,
      tag: json['tag'],
      guestCategoryUuid: json['guest_category_uuid'],
      guestCategoryName: json['guest_category_name'],
      gender: Gender.values.firstWhere((e) => e.name == json['gender'], orElse: () => Gender.male),
      checkedInAt: json['checked_in_at'] != null ? DateTime.parse(json['checked_in_at']) : null,
      checkedOutAt: json['checked_out_at'] != null ? DateTime.parse(json['checked_out_at']) : null,
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
    );
  }

  // copyWith
  GuestsModel copyWith({
    String? guestUuid,
    String? eventUuid,
    String? name,
    String? phone,
    String? qrValue,
    bool? isCheckedIn,
    String? tag,
    String? guestCategoryUuid,
    String? guestCategoryName,
    Gender? gender,
    DateTime? checkedInAt,
    DateTime? checkedOutAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? eventName,
    bool? isDeleted,
    DateTime? deletedAt,
    String? photoPath,
    String? photoUrl,
  }) {
    return GuestsModel(
      guestUuid: guestUuid ?? this.guestUuid,
      eventUuid: eventUuid ?? this.eventUuid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      qrValue: qrValue ?? this.qrValue,

      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      tag: tag ?? this.tag,
      guestCategoryUuid: guestCategoryUuid ?? this.guestCategoryUuid,
      guestCategoryName: guestCategoryName ?? this.guestCategoryName,
      gender: gender ?? this.gender,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      checkedOutAt: checkedOutAt ?? this.checkedOutAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      eventName: eventName ?? this.eventName,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      photoPath: photoPath ?? this.photoPath,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toSyncJson() {
    return {
      'id': guestUuid,
      'event_id': eventUuid,
      'name': name,
      'phone': phone,
      'qr_value': qrValue,
      'is_checked_in': isCheckedIn,
      'tag': tag,
      'gender': gender.name,
      'guest_category_uuid': guestCategoryUuid,
      'guest_category_name': guestCategoryName,
      'checked_in_at': checkedInAt?.toUtc().toIso8601String(), // ✅ Convert ke string
      'checked_out_at': checkedOutAt?.toUtc().toIso8601String(), // ✅ Convert ke string
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
      isCheckedIn: json['is_checked_in'],
      gender: Gender.values.firstWhere((e) => e.name == json['gender'], orElse: () => Gender.male),
      guestCategoryUuid: json['guest_category_uuid'],
      guestCategoryName: json['guest_category_name'],
      checkedInAt: json['checked_in_at'] != null ? DateTime.parse(json['checked_in_at']) : null,
      checkedOutAt: json['checked_out_at'] != null ? DateTime.parse(json['checked_out_at']) : null,
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
