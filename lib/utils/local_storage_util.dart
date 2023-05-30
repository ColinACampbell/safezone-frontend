import 'dart:convert';

import 'package:safezone_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _LocalStorageUtil {
  saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(user.toString());
    prefs.setString("user_data", user.toString());
  }

  Future<User?> getCurrentUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJsonString = prefs.getString("user_data");

    if (userJsonString == null) {
      return null;
    } else {
      Map<String, dynamic> userjson = json.decode(userJsonString);
      return User.fromJson(userjson);
    }
  }
}

final localStorageUtil = _LocalStorageUtil();
