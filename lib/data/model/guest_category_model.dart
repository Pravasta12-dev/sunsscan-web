import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/enum/enum.dart';

class GuestCategoryModel extends Equatable {
  final String? categoryUuid;
  final String eventUuid;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;
  final bool isDeleted;
  final DateTime? deletedAt;

  const GuestCategoryModel({
    this.categoryUuid,
    required this.eventUuid,
    required this.name,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.isDeleted = false,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    categoryUuid,
    eventUuid,
    name,
    createdAt,
    updatedAt,
    syncStatus,
    isDeleted,
    deletedAt,
  ];
  Map<String, dynamic> toJson() {
    return {
      'category_uuid': categoryUuid,
      'event_uuid': eventUuid,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'sync_status': syncStatus.name,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toSyncJson() {
    return {
      'id': categoryUuid,
      'event_id': eventUuid,
      'name': name,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt?.toUtc().toIso8601String(),
      'sync_status': syncStatus.name,
      'is_deleted': isDeleted,
      'deleted_at': deletedAt?.toUtc().toIso8601String(),
    };
  }

  GuestCategoryModel copyWith({
    String? categoryUuid,
    String? eventUuid,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return GuestCategoryModel(
      categoryUuid: categoryUuid ?? this.categoryUuid,
      eventUuid: eventUuid ?? this.eventUuid,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory GuestCategoryModel.fromJson(Map<String, dynamic> json) {
    return GuestCategoryModel(
      categoryUuid: json['category_uuid'] as String?,
      eventUuid: json['event_uuid'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      syncStatus: json['sync_status'] != null
          ? SyncStatus.values.firstWhere(
              (e) => e.name == json['sync_status'],
              orElse: () => SyncStatus.pending,
            )
          : SyncStatus.pending,
      isDeleted: json['is_deleted'] == 1,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }

  factory GuestCategoryModel.fromSyncJson(Map<String, dynamic> json) {
    return GuestCategoryModel(
      categoryUuid: json['id'] as String?,
      eventUuid: json['event_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      syncStatus: json['sync_status'] != null
          ? SyncStatus.values.firstWhere(
              (e) => e.name == json['sync_status'],
              orElse: () => SyncStatus.pending,
            )
          : SyncStatus.pending,
      isDeleted: json['is_deleted'] == true,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }
}
