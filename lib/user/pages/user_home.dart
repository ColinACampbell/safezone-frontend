import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/utils.dart';
import 'package:safezone_frontend/widgets/map.dart';

class UserHomePage extends ConsumerStatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);
  @override
  ConsumerState<UserHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<UserHomePage> {
  @override
  void initState() {
    final currentUser = ref.read(userProvider).currentUser;
    final channel =
        serverClient.connectToLocationsStreaming(currentUser!.token!);
    channel.stream.listen((event) {
      print(event);
    });

    Timer.periodic(const Duration(seconds: 6), (timer) {
      channel.sink.add("demo");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: AppMap(locationsStream: null, initLat: 0, initLong: 0)),
          ],
        ),
      ),
    );
  }

  showCoordinates(lat, long) {
    return Text("Lat is $lat, Long is $long");
  }
}
