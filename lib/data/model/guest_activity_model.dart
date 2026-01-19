class GuestActivityModel {
  final String name;
  final String? phone;
  final String? photoPath;
  final String? photoUrl;
  final String? categoryName;
  final DateTime checkInAt;
  final DateTime? checkOutAt;

  GuestActivityModel({
    required this.name,
    this.phone,
    this.photoPath,
    this.photoUrl,
    this.categoryName,
    required this.checkInAt,
    this.checkOutAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'photo_path': photoPath,
      'photo_url': photoUrl,
      'category_name': categoryName,
      'checkin_at': checkInAt.toIso8601String(),
      'checkout_at': checkOutAt?.toIso8601String(),
    };
  }

  // fromJson
  factory GuestActivityModel.fromJson(Map<String, dynamic> json) {
    return GuestActivityModel(
      name: json['name'],
      phone: json['phone'],
      photoPath: json['photo_path'],
      photoUrl: json['photo_url'],
      categoryName: json['category_name'],
      checkInAt: DateTime.parse(json['checkin_at']),
      checkOutAt: json['checkout_at'] != null ? DateTime.parse(json['checkout_at']) : null,
    );
  }
}
