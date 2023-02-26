import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  late final User currentUser;

  UserProvider(this._userRepository);

  login(String email, String password) async {
    currentUser = await _userRepository.loginUser(email, password);
    notifyListeners();
  }
}
