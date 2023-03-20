import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  User? currentUser;
  var prefs = SharedPreferences.getInstance();

  UserProvider(this._userRepository);

  login(String email, String password) async {
    currentUser = await _userRepository.loginUser(email, password);

    (await prefs).setString("token", currentUser!.token!);
    notifyListeners();
  }
}
