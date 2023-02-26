class User {
  final String _email, _token, _name;
  User(this._name, this._email, this._token);

  get email {
    return _email;
  }

  get name {
    return _name;
  }

  User.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _email = json['email'],
        _token = json['token'];
}
