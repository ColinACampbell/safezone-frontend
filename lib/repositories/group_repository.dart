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

  Future<Group> addConfidant(
      int userId, int groupId, String role, String token) async {
    Map<String, dynamic> body = {
      "user_id": userId,
      "group_id": groupId,
      "role": role
    };

    Map<String, dynamic> respBody = await serverClient
        .post("/groups/$groupId/confidants", body, token: token);
    return Group.fromJson(respBody);
  }

  Future<Group> fetchgroup(int groupId, String token) async {
    Map<String, dynamic> respBody =
        await serverClient.get("/groups/$groupId", token: token);
    return Group.fromJson(respBody);
  }

  // toTime and fromTime is in 24 hours
  Future<GeoRestriction> geofenceUser(
      int groupId,
      int userId,
      double lat,
      double long,
      double radius,
      int fromTime,
      int toTime,
      String token) async {
    Map<String, dynamic> body = {
      "user_id": userId,
      "group_id": groupId,
      "latitude": lat,
      "longitude": long,
      "radius": radius,
      "from_time": fromTime,
      "to_time": toTime
    };
    Map<String, dynamic> respBody = await serverClient
        .post("/groups/$groupId/restriction", body, token: token);
    return GeoRestriction.fromJson(respBody);
  }

  Future<List<GeoRestriction>> fetchGeofence(
      int groupId, int userId, String token) async {
    List<dynamic> respBody = await serverClient
        .get("/groups/$groupId/restriction/$userId", token: token);
    return respBody.map((e) => GeoRestriction.fromJson(e)).toList();
  }
}
