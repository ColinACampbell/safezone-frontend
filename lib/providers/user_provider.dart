import 'package:flutter/material.dart';
import 'package:safezone_frontend/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  UserProvider(this._userRepository);

  login(String email, String password) {
    _userRepository.loginUser(email, password);
  }
}
