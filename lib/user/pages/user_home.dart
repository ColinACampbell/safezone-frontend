import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/providers.dart';

class UserHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.read(userProvider).currentUser!;
    return Center(child: Text("Welcome ${user.firstname} ${user.lastname}"));
  }
}
