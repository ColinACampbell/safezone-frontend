import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/group/add_geo_fence.dart';
import 'package:safezone_frontend/user/pages/group/confidant_card.dart';
import 'package:safezone_frontend/user/pages/group/group_confidants.dart';
import 'package:safezone_frontend/utils/location_util.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/map.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UserGroupPage extends ConsumerStatefulWidget {
  static const String routeName = "/user_group_page";

  const UserGroupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserGroupPageState();
  }
}

class UserGroupPageState extends ConsumerState<UserGroupPage> {
  
  Timer? locationUpdateTimer;

  startListening(WebSocketChannel? groupChannel) {
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      groupChannel!.sink.add("");
    });
  }

  stopListening() {
    locationUpdateTimer!.cancel();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final group = ModalRoute.of(context)!.settings.arguments as Group;
      final groupChannel =
          ref.read(groupsProvider).groupConnections[group.id];


      startListening(groupChannel);
      // ref.read(locationProvider).getLocationStream().listen((event) async {
      //   print("Location Changed to ${event.latitude}, ${event.longitude}");
      //   // List<Placemark> placemarks =
      //   //     await placemarkFromCoordinates(event.latitude!, event.longitude!);
      //   // print(placemarks.length);
      //   groupChannel!.sink
      //       .add(locationUtil.getUserLocationData(currentUser, event));
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopListening();
  }

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group;
    final groupContainer = ref.watch(groupsProvider);

    final broadcast = groupContainer.groupConnections[group.id]!;

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: group.name,
            iconButton: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddGeoFenceScreen.routeName);
                },
                icon: Icon(Icons.group_add)),
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
                          locationsStream: broadcast
                              .stream, // pass is the streams from the server
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
                              child: const Text(
                                "My Confidants",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, GroupConfidants.routeName,
                                          arguments: group.id);
                                    },
                                    child: Text("Show All")),
                              ],
                            )
                          ],
                        )),
                    Expanded(
                      child: ListView.builder(
                        itemCount: group.confidants.length,
                        itemBuilder: (context, idx) {
                          return ConfidantCard(group.confidants[idx],
                              group.confidants.last == group.confidants[idx]);
                        },
                      ),
                    )
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
