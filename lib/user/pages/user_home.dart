import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/utils/geo_locator.dart';
import 'package:safezone_frontend/widgets/map.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:workmanager/workmanager.dart';

class UserHomePage extends ConsumerStatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);
  @override
  ConsumerState<UserHomePage> createState() => _HomePageState();
}

// TODO: Check out to dispose this completely when the user changes page
class _HomePageState extends ConsumerState<UserHomePage> {


  Timer? locationUpdateTimer;

  startListening(WebSocketChannel? groupChannel) {
    print("Started listening");
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      groupChannel!.sink.add("");
    });
  }

  stopListening() {
    locationUpdateTimer!.cancel();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await Workmanager().registerOneOffTask("BACKGROUND_UPDATE", "BACKGROUND_UPDATE");
      startListening(ref.read(userProvider).generalGroupsStream);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future:getPosition(), // TODO: Change
                  builder: (context, snapshot) {
                    double initLat = 0, initLong = 0;

                    if (snapshot.hasData) {
                      Position position = snapshot.data as Position;
                      initLat = position.latitude;
                      initLong = position.longitude;
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
