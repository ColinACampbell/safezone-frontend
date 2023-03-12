class User {
  final String email, firstname, lastname;
  final int id;
  String? token;
  User(this.id, this.firstname, this.lastname, this.email, this.token);
  User.asConfidant(this.id, this.firstname, this.lastname, this.email);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['first_name'],
        lastname = json['last_name'],
        email = json['email'],
        token = json['token'];

  User.fromJsonAsConfidant(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['first_name'],
        lastname = json['last_name'],
        email = json['email'];
}

class UserLocation {
  final double lat, lon;
  final int id;
  final String name;
  UserLocation(this.id, this.name, this.lat, this.lon);
}
