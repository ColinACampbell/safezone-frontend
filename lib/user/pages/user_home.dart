import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/utils.dart';
import 'package:safezone_frontend/utils/location_util.dart';
import 'package:safezone_frontend/widgets/map.dart';

class UserHomePage extends ConsumerStatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);
  @override
  ConsumerState<UserHomePage> createState() => _HomePageState();
}

// TODO: Check out to dispose this completely when the user changes page
class _HomePageState extends ConsumerState<UserHomePage> {

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {

      await ref.read(locationProvider).initLocationUtil();
      ref.read(locationProvider).getLocationStream().listen((event) async {
        // ignore: avoid_print
        print("Location Changed to ${event.latitude}, ${event.longitude}");
        final currentUser = ref.read(userProvider).currentUser!;
        ref.read(userProvider).generalGroupsStream!.sink.add(locationUtil.getUserLocationData(currentUser, event));
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: locationUtil.getLocation(),
                  builder: (context, snapshot) {
                    double initLat = 0, initLong = 0;

                    if (snapshot.hasData) {
                      LocationTuple tuple = snapshot.data as LocationTuple;
                      initLat = tuple.locationData.latitude!;
                      initLong = tuple.locationData.longitude!;
                      return AppMap(
                          locationsStream:
                              ref.watch(userProvider).groupsBroadCast,
                          initLat: initLat,
                          initLong: initLong);
                    } else {
                      return const Text("Loading");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  showCoordinates(lat, long) {
    return Text("Lat is $lat, Long is $long");
  }
}
