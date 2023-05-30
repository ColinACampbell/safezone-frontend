import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/utils.dart';

class GroupRepository {
  Future<Group> createGroup(String name, String token) async {
    Map<String, dynamic> body = {"name": name};
    Map<String, dynamic> respBody =
        await serverClient.post("/groups/", body, token: token);
    return Group.fromJson(respBody);
  }

  Future<List<Group>> fetchgroups(String token) async {
    List<dynamic> respBody = await serverClient.get("/groups/", token: token);
    return respBody.map((e) => Group.fromJson(e)).toList();
  }

  Future<Group> fetchgroup(int groupId, String token) async {
    Map<String, dynamic> respBody =
        await serverClient.get("/groups/$groupId", token: token);
    return Group.fromJson(respBody);
  }
}
