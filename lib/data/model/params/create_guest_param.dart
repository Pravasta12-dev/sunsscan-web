import 'package:sun_scan/core/enum/enum.dart';

class CreateGuestParam {
  final String? guestUuid;
  final String eventId;
  final String name;
  final String qrValue;
  final Gender gender;
  final String? phone;
  final String? tag;
  final String? guestCategoryUuid;
  final String? guestCategoryName;
  final String? photo;

  CreateGuestParam({
    this.guestUuid,
    required this.eventId,
    required this.name,
    required this.qrValue,
    required this.gender,
    this.phone,
    this.tag,
    this.guestCategoryUuid,
    this.guestCategoryName,
    this.photo,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'name': name,
      'qr_value': qrValue,
      'gender': gender.name,
      'phone': phone,
      'tag': tag,
      'guest_category_uuid': guestCategoryUuid,
      'guest_category_name': guestCategoryName,
      'photo_path': photo,
    };
  }
}
