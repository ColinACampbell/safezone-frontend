class MedicalRecord {
  int id;
  int userId;
  String title;
  String description;

  MedicalRecord(this.id, this.userId, this.title, this.description);
  MedicalRecord.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        title = json['title'],
        description = json['description'];
}
