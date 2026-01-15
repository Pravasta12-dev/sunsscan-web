import 'package:equatable/equatable.dart';
import 'package:sun_scan/core/enum/enum.dart';
import 'package:sun_scan/core/helper/image_picker_helper.dart';

enum PhotoType { identity, checkIn, other }

class GuestPhotoModel extends Equatable {
  final String photoUuid;
  final String guestUuid;
  final String eventUuid;

  final PhotoType photoType;

  final String fileName;
  final String filePath;
  final int? fileSize; // in bytes
  final String? mimeType;

  final PickImageSource source;
  final bool isPrimary;

  final String? fileUrl;
  final SyncStatus syncStatus;

  final DateTime createdAt;
  final DateTime? updatedAt;

  final bool isDeleted;
  final DateTime? deletedAt;

  const GuestPhotoModel({
    required this.photoUuid,
    required this.guestUuid,
    required this.eventUuid,
    required this.photoType,
    required this.fileName,
    required this.filePath,
    this.fileSize,
    this.mimeType,
    this.source = PickImageSource.camera,
    this.isPrimary = false,
    this.fileUrl,
    this.syncStatus = SyncStatus.pending,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    photoUuid,
    guestUuid,
    eventUuid,
    photoType,
    fileName,
    filePath,
    fileSize,
    mimeType,
    source,
    isPrimary,
    fileUrl,
    syncStatus,
    createdAt,
    updatedAt,
    isDeleted,
    deletedAt,
  ];

  //fromJson
  factory GuestPhotoModel.fromJson(Map<String, dynamic> json, {bool isOnline = false}) {
    return GuestPhotoModel(
      photoUuid: json['photo_uuid'],
      guestUuid: json['guest_uuid'],
      eventUuid: json['event_uuid'],
      photoType: PhotoType.values.firstWhere((e) => e.name == json['photo_type']),
      fileName: json['file_name'],
      filePath: json['file_path'],
      fileSize: json['file_size'],
      mimeType: json['mime_type'],
      source: PickImageSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => PickImageSource.camera,
      ),
      isPrimary: isOnline ? (json['is_primary'] ?? false) : (json['is_primary'] == 1),
      fileUrl: json['file_url'],
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      isDeleted: isOnline ? (json['is_deleted'] ?? false) : (json['is_deleted'] == 1),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo_uuid': photoUuid,
      'guest_uuid': guestUuid,
      'event_uuid': eventUuid,
      'photo_type': photoType.name,
      'file_name': fileName,
      'file_path': filePath,
      'file_size': fileSize,
      'mime_type': mimeType,
      'source': source.name,
      'is_primary': isPrimary ? 1 : 0,
      'file_url': fileUrl,
      'sync_status': syncStatus.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toSyncPayload() {
    return {
      'photo_uuid': photoUuid,
      'guest_uuid': guestUuid,
      'event_uuid': eventUuid,
      'photo_type': photoType.name,

      // 🔥 WAJIB ADA
      'file_path': filePath, // path lokal (opsional tapi konsisten)
      'file_url': fileUrl, // URL dari upload endpoint

      'file_name': fileName,
      'file_size': fileSize,
      'mime_type': mimeType,
      'source': source.name,
      'is_primary': isPrimary,
      'is_deleted': isDeleted,
      'deleted_at': deletedAt?.toIso8601String(),
      'sync_status': syncStatus.name,

      // ❌ JANGAN kirim created_at
      // ❌ JANGAN kirim updated_at
    };
  }

  GuestPhotoModel copyWith({
    String? fileUrl,
    SyncStatus? syncStatus,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return GuestPhotoModel(
      photoUuid: photoUuid,
      guestUuid: guestUuid,
      eventUuid: eventUuid,
      photoType: photoType,
      fileName: fileName,
      filePath: filePath,
      fileSize: fileSize,
      mimeType: mimeType,
      source: source,
      isPrimary: isPrimary,
      fileUrl: fileUrl ?? this.fileUrl,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
