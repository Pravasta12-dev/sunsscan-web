class CreateGuestCategoryParam {
  final String eventUuid;
  final String name;

  CreateGuestCategoryParam({required this.eventUuid, required this.name});

  Map<String, dynamic> toJson() {
    return {'event_id': eventUuid, 'name': name};
  }
}
