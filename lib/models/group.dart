import 'package:safezone_frontend/models/user.dart';

class Group {
  final String name;
  final int id;
  final int createdBy;
  final List<Confidant> confidants;
  Group(this.id, this.createdBy, this.name, this.confidants);

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdBy = json['created_by'],
        confidants = (json['confidants'] as List)
            .map((jsonConfidant) => Confidant.fromJson(jsonConfidant))
            .toList();
}

class Confidant {
  final int id;
  final User details;
  Confidant(this.id, this.details);

  Confidant.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        details = User.fromJsonAsConfidant(json['details']);
}

class GeoRestriction {
  final int userId;
  final int groupId;
  final int latitude;
  final int longitude;
  final int radius;

  GeoRestriction(
      this.userId, this.groupId, this.latitude, this.longitude, this.radius);

  GeoRestriction.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        groupId = json['group_id'],
        latitude = json['latidude'],
        longitude = json['longitude'],
        radius = json["radius"];
}
