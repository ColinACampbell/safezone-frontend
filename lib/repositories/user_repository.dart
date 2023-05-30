import 'package:safezone_frontend/models/exception.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/utils.dart';

class UserRepository {
  Future<User> loginUser(String email, String password) async {
    Map<String, dynamic> body = {"email": email, "password": password};
    Map<String, dynamic> respBody =
        await serverClient.post("/users/auth", body);
    print(respBody);
    return User.fromJson(respBody);
  }
  Future<User> signupUser(
      String firstName, String lastName, String email, String password) async {
    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password
    };
    Map<String, dynamic> respBody =
        await serverClient.post("/users", body);
    print(respBody);
    return User.fromJson(respBody);
  }
}