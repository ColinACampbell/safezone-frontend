class User {
  final String email, token, firstname, lastname;
  final int id;
  User(this.id, this.firstname, this.lastname, this.email, this.token);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['first_name'],
        lastname = json['last_name'],
        email = json['email'],
        token = json['token'];
}
