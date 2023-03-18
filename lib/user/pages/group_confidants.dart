import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';

class GroupConfidants extends ConsumerStatefulWidget {
  static final String routeName = "/group_confidant";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _GroupConfidantsState();
  }
}

class _GroupConfidantsState extends ConsumerState<GroupConfidants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [CustomAppBar(title: "My Confidants")],
      ),
    );
  }
}
