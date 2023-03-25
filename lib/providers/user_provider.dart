import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/repositories/user_repository.dart';
import 'package:safezone_frontend/utils/local_storage_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  User? currentUser;
  var prefs = SharedPreferences.getInstance();

  UserProvider(this._userRepository);

  Future<void> login(String email, String password) async {
    currentUser = await _userRepository.loginUser(email, password);
    await localStorageUtil.saveUser(currentUser!);
    notifyListeners();
  }

  set setCurrentUser(User currentUser) {
    this.currentUser = currentUser;
    notifyListeners();
  }

  signup(
      String firstName, String lastName, String email, String password) async {
    currentUser =
        await _userRepository.signupUser(firstName, lastName, email, password);
    notifyListeners();
  }
}
