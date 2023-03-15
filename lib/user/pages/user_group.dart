import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/utils.dart';
import 'package:safezone_frontend/utils/location_util.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/map.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UserGroupPage extends ConsumerStatefulWidget {
  static const String routeName = "/user_group_page";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserGroupPageState();
  }
}

class UserGroupPageState extends ConsumerState<UserGroupPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final group = ModalRoute.of(context)!.settings.arguments as Group;
      final groupChannel =
          ref.read(groupsProvider).groupConnections[group.name];

      final currentUser = ref.read(userProvider).currentUser!;

      // groupChannel!.stream.asBroadcastStream().listen((event) {}, onDone: () {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(const SnackBar(content: Text("Connection Closed")));
      // }, onError: (error) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text("Recieved error $error")));
      // });

      (await locationUtil.getLocationObject())
          .onLocationChanged
          .listen((event) {
        print("Location Changed to ${event.latitude}, ${event.longitude}");
        groupChannel!.sink
            .add(locationUtil.getUserLocationData(currentUser, event));
      });
    });
  }

  Widget buildConfidantCard(Confidant confidant) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${confidant.details.firstname} ${confidant.details.lastname}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    Icon(Icons.location_on),
                    Text(
                      "UWI, Mona",
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group;
    final groupContainer = ref.watch(groupsProvider);

    final channel = groupContainer.groupConnections[group.name];

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: group.name,
          ),
          Expanded(
              child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FutureBuilder(
                  future: locationUtil.getLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      LocationTuple location = snapshot.data as LocationTuple;
                      return AppMap(
                          locationsStream: groupContainer
                              .groupConnections[group.name]!.stream
                              .asBroadcastStream(), // pass is the streams from the server
                          initLat: location.locationData.latitude!,
                          initLong: location.locationData.longitude!);
                    } else {
                      return const Text("Loading");
                    }
                  }),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Column(
                  children: [
                    Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "My Confidants",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            TextButton(
                                onPressed: () {}, child: Text("Show All"))
                          ],
                        )),
                    Expanded(
                        child: ListView.builder(
                            itemCount: group.confidants.length,
                            itemBuilder: (context, idx) {
                              return buildConfidantCard(group.confidants[idx]);
                            }))
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
