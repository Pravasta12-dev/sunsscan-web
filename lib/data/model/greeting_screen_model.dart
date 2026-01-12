import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/enum/enum.dart';

enum GreetingType { image, video }

enum GreetingAddingBy { admin, client }

class GreetingScreenModel extends Equatable {
  final String greetingUuid;
  final String eventUuid;
  final GreetingType greetingType;
  final String name;
  final String contentPath;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;
  final GreetingAddingBy addedBy;
  final bool isDeleted;
  final DateTime? deletedAt;

  const GreetingScreenModel({
    required this.greetingUuid,
    required this.eventUuid,
    required this.greetingType,
    required this.name,
    required this.contentPath,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.addedBy = GreetingAddingBy.admin,
    this.isDeleted = false,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    greetingUuid,
    eventUuid,
    greetingType,
    name,
    contentPath,
    createdAt,
    updatedAt,
    syncStatus,
    addedBy,
    isDeleted,
    deletedAt,
  ];

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'greeting_uuid': greetingUuid,
      'event_uuid': eventUuid,
      'content_type': greetingType.name,
      'name': name,
      'content_path': contentPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'sync_status': syncStatus.name,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
      'added_by': addedBy.name,
    };
  }

  // fromJson
  factory GreetingScreenModel.fromJson(Map<String, dynamic> json) {
    return GreetingScreenModel(
      greetingUuid: json['greeting_uuid'],
      eventUuid: json['event_uuid'],
      greetingType: GreetingType.values.firstWhere(
        (e) => e.name == json['content_type'],
        orElse: () => GreetingType.image,
      ),
      name: json['name'],
      contentPath: json['content_path'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
      isDeleted: json['is_deleted'] == 1,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      addedBy: GreetingAddingBy.values.firstWhere(
        (e) => e.name == json['added_by'],
        orElse: () => GreetingAddingBy.admin,
      ),
    );
  }

  // copyWith
  GreetingScreenModel copyWith({
    String? greetingUuid,
    String? eventUuid,
    GreetingType? greetingType,
    String? name,
    String? contentPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    bool? isDeleted,
    DateTime? deletedAt,
    GreetingAddingBy? addedBy,
  }) {
    return GreetingScreenModel(
      greetingUuid: greetingUuid ?? this.greetingUuid,
      eventUuid: eventUuid ?? this.eventUuid,
      greetingType: greetingType ?? this.greetingType,
      name: name ?? this.name,
      contentPath: contentPath ?? this.contentPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      addedBy: addedBy ?? this.addedBy,
    );
  }
}
