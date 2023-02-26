import 'package:safezone_frontend/utils.dart';

class UserRepository {
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    Map<String, dynamic> body = {"email": email, "password": password};
    return serverClient.post("/users/auth", body);
  }
}
