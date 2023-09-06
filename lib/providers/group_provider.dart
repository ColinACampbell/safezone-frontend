import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/providers/user_provider.dart';
import 'package:safezone_frontend/repositories/group_repository.dart';
import 'package:safezone_frontend/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GroupProvider extends ChangeNotifier {
  final GroupRepository _groupRepository;
  final UserProvider _userProvider;

  List<Group> groups = [];
  List<Group> tempGroups = []; // use when searching
  Map<int, WebSocketChannel> groupConnections = {};

  GroupProvider(this._groupRepository, this._userProvider);

  createGroup(String groupName) async {
    final newGroup = await _groupRepository.createGroup(
        groupName, _userProvider.currentUser!.token!);
    groups.add(newGroup);
    notifyListeners();
  }

  Future<List<Group>> fetchGroups() async {
    var newGroups =
        await _groupRepository.fetchgroups(_userProvider.currentUser!.token!);
    groups = [];
    groups.addAll(newGroups);
    notifyListeners();
    return groups;
  }

  connectToGroup(int groupId) {
    final newChannel = serverClient.joinGroupSocketRoom(groupId);
    groupConnections[groupId] = newChannel;
    notifyListeners();
  }

  Future<Group> fetchGroup(int groupId) async {
    var group = await _groupRepository.fetchgroup(
        groupId, _userProvider.currentUser!.token!);

    var oldGroup = groups.firstWhere((g) => g.id == groupId);
    groups.remove(oldGroup);
    groups.add(group);
    notifyListeners();
    return group;
  }

  Future<GeoRestriction> geofenceUser(int groupId, int userId, double lat,
      double long, double radius, int fromTime, int toTime) {
    return _groupRepository.geofenceUser(groupId, userId, lat, long, radius,
        fromTime, toTime, _userProvider.currentUser!.token!);
  }

  Future<List<GeoRestriction>> fetchUserGeofence(int groupId, int userId) async {
    print("Fetching now");
    var ss = await _groupRepository.fetchGeofence(
        groupId, userId, _userProvider.currentUser!.token!);
      print(ss);
      return ss;
  }

  Future<Group> addConfidant(int userId, int groupId, String role) async {
    var updatedGroup = await _groupRepository.addConfidant(
        userId, groupId, role, _userProvider.currentUser!.token!);

    for (int i = 0; i < groups.length; i++) {
      if (groups[i].id == updatedGroup.id) {
        groups[i].confidants = updatedGroup.confidants;
        notifyListeners();
      }
    }

    return updatedGroup;
  }


  void searchForGroups(String lookupName) {

    if (tempGroups.isEmpty) {
      tempGroups = [...groups];
    } else {
      groups = [...tempGroups];
    }

    final filteredGroups = tempGroups.where((group) => group.name.contains(lookupName)).toList();
    groups = [...filteredGroups];
    notifyListeners();
  }

  Stream<dynamic> getGroupConnectionAsBroadCast(int groupId) {
    var channel = groupConnections[groupId];
    return channel!.stream.asBroadcastStream();
  }
}
