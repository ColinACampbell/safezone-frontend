import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/group/confidant_card.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/app_text_field.dart';

class GroupConfidants extends ConsumerStatefulWidget {
  static final String routeName = "/group_confidant";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _GroupConfidantsState();
  }
}

class _GroupConfidantsState extends ConsumerState<GroupConfidants> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final int groupId = ModalRoute.of(context)!.settings.arguments as int;
      await ref.read(groupsProvider).fetchGroup(groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;
    final group =
        ref.watch(groupsProvider).groups.firstWhere((g) => g.id == groupId);
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "My Confidants"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppTextField(hintText: "Search", onSaved: (val) {}),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: group.confidants.length,
                  itemBuilder: (context, idx) {
                    return ConfidantCard(group.confidants[idx], group,
                        group.confidants.last == group.confidants[idx]);
                  }))
        ],
      ),
    );
  }
}
