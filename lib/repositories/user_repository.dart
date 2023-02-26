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
}
