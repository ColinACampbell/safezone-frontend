import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/map.dart';

class UserGroupPage extends ConsumerStatefulWidget {
  static const String routeName = "/user_group_page";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserGroupPageState();
  }
}

class UserGroupPageState extends ConsumerState<UserGroupPage> {
  late final Group group;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      group = ModalRoute.of(context)!.settings.arguments as Group;
      print(group.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(),
          Expanded(
              child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AppMap(initLat: 0, initLong: 0),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                width: MediaQuery.of(context).size.width,
                height: 300,
              )
            ],
          ))
        ],
      ),
    );
  }
}
