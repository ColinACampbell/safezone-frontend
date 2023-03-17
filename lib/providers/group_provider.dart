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
  Map<String, WebSocketChannel> groupConnections = {};

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

  connectToGroup(String groupName) {
    final newChannel = serverClient.joinGroupSocketRoom(groupName);
    groupConnections[groupName] = newChannel;
    notifyListeners();
  }

  Stream<dynamic> getGroupConnectionAsBroadCast(String groupName) {
    var channel = groupConnections[groupName];
    return channel!.stream.asBroadcastStream();
  }
}
