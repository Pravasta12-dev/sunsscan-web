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
  final String? guestCategoryUuid;
  final String? guestCategoryName;
  final String? photo;
  final DateTime? checkedInAt;
  final DateTime? checkedOutAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;

  final String? eventName; // Tambahkan properti eventName

  const GuestsModel({
    this.guestUuid,
    required this.eventUuid,
    required this.name,
    this.phone,
    required this.qrValue,
    required this.isCheckedIn,
    this.guestCategoryUuid,
    this.guestCategoryName,
    this.gender = Gender.male,
    this.photo,
    this.checkedInAt,
    this.checkedOutAt,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.eventName,
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
    isCheckedIn,
    photo,
    checkedInAt,
    checkedOutAt,
    createdAt,
    updatedAt,
    syncStatus,
    gender,
    eventName,
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
      'guest_category_uuid': guestCategoryUuid,
      'guest_category_name': guestCategoryName,
      'gender': gender.name,
      'photo': photo,
      'checked_in_at': checkedInAt?.toIso8601String(),
      'checked_out_at': checkedOutAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'sync_status': syncStatus.name,
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
      guestCategoryUuid: json['guest_category_uuid'],
      guestCategoryName: json['guest_category_name'],
      gender: Gender.values.firstWhere((e) => e.name == json['gender'], orElse: () => Gender.male),
      photo: json['photo'], // FIX: Changed from 'base64_photo' to 'photo'
      checkedInAt: json['checked_in_at'] != null ? DateTime.parse(json['checked_in_at']) : null,
      checkedOutAt: json['checked_out_at'] != null ? DateTime.parse(json['checked_out_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
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
    String? guestCategoryUuid,
    String? guestCategoryName,
    Gender? gender,
    String? photo,
    DateTime? checkedInAt,
    DateTime? checkedOutAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? eventName,
  }) {
    return GuestsModel(
      guestUuid: guestUuid ?? this.guestUuid,
      eventUuid: eventUuid ?? this.eventUuid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      qrValue: qrValue ?? this.qrValue,
      photo: photo ?? this.photo,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      guestCategoryUuid: guestCategoryUuid ?? this.guestCategoryUuid,
      guestCategoryName: guestCategoryName ?? this.guestCategoryName,
      gender: gender ?? this.gender,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      checkedOutAt: checkedOutAt ?? this.checkedOutAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      eventName: eventName ?? this.eventName,
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
      'gender': gender.name,
      'guest_category_uuid': guestCategoryUuid,
      'guest_category_name': guestCategoryName,
      'photo_path': photo, // ✅ Changed key to 'photo_path'
      'checked_in_at': checkedInAt?.toUtc().toIso8601String(), // ✅ Convert ke string
      'checked_out_at': checkedOutAt?.toUtc().toIso8601String(), // ✅ Convert ke string
      'created_at': createdAt.toUtc().toIso8601String(), // ✅ Convert ke string
      'updated_at': updatedAt?.toUtc().toIso8601String(), // ✅ Convert ke string
      'sync_status': syncStatus.name,
    };
  }

  factory GuestsModel.fromJsonOnline(Map<String, dynamic> json) {
    return GuestsModel(
      guestUuid: json['id'],
      eventUuid: json['event_id'],
      name: json['name'],
      phone: json['phone'],
      qrValue: json['qr_value'],
      isCheckedIn: json['is_checked_in'],
      gender: Gender.values.firstWhere((e) => e.name == json['gender'], orElse: () => Gender.male),
      guestCategoryUuid: json['guest_category_uuid'],
      guestCategoryName: json['guest_category_name'],
      photo: json['photo_path'], // FIX: Changed from 'base64_photo' to 'photo_path'
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
    );
  }
}
