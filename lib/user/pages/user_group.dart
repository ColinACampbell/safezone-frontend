import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/utils.dart';
import 'package:safezone_frontend/utils/location_util.dart';
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
    Future.delayed(Duration.zero, () async {
      group = ModalRoute.of(context)!.settings.arguments as Group;
      final groupChannel = serverClient.joinGroupSocketRoom(group.name);
      groupChannel.sink.add("Hello World, this is the first message");
      (await locationUtil.getLocation()).onLocationChanged.listen((event) {
        var data = json.encode({"lat": event.latitude, "lon": event.longitude});
        groupChannel.sink.add(data);
      });
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
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
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
