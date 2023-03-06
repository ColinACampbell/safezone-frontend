import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/app_text_field.dart';

class UserGroupPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserGroupsState();
  }
}

class UserGroupsState extends ConsumerState<UserGroupPage> {
  initState() {
    super.initState();
    ref.read(groupsProvider).fetchGroups();
  }

  buildGroupCard(Group group) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: const BoxDecoration(
          // color: Colors.red,
          border: Border(
              bottom: BorderSide(
                  color: Color.fromRGBO(217, 217, 217, 1), width: 1))),
      height: 64,
      width: 100,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(50)),
                color: Colors.red),
            width: 40,
            height: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            group.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: AppTextField(hintText: "Search", onSaved: (val) {}),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.read(groupsProvider).fetchGroups();
            },
            child: FutureBuilder(
              future: Future.value(ref.watch(groupsProvider).groups),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final groups = snapshot.data as List<Group>;

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, idx) {
                      return buildGroupCard(groups[idx]);
                    },
                  );
                } else {
                  return Text("Loading");
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
