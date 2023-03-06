import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/providers/user_provider.dart';
import 'package:safezone_frontend/repositories/group_repository.dart';
import 'package:safezone_frontend/repositories/user_repository.dart';

class GroupProvider extends ChangeNotifier {
  final GroupRepository _groupRepository;
  final UserProvider _userProvider;

  List<Group> groups = [];

  GroupProvider(this._groupRepository, this._userProvider);

  createGroup(String groupName) async {
    final newGroup = await _groupRepository.createGroup(
        groupName, _userProvider.currentUser!.token!);
    groups.add(newGroup);
    notifyListeners();
  }

  fetchGroups() async {
    var newGroups =
        await _groupRepository.fetchgroups(_userProvider.currentUser!.token!);
    groups = [];
    groups.addAll(newGroups);
    notifyListeners();
  }
}
