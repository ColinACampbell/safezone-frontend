import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/user_sos.dart';
import 'package:safezone_frontend/utils/geo_locator.dart';
import 'package:safezone_frontend/widgets/map.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as developer;

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
      final memberLocations = ref.read(notificationProvider).membersLocations;
      final members = memberLocations.keys.toList();

      for (int i = 0; i < members.length; i++) {
        final memberId = members[i];
        if (ref
            .read(notificationProvider)
            .geoFenceFlags
            .containsKey(memberId)) {
          if (ref.read(notificationProvider).geoFenceFlags[memberId] == true) {
            final memberLocation = memberLocations[memberId];
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: 10,
                    channelKey: 'safe_zone_key1',
                    title: "${memberLocation!.name} is outside geofence!",
                    body:
                        "${memberLocation.name} is ${memberLocation.geoFenceDistance.round()} meters away from the center of geofence!"));
            ref.read(notificationProvider).markGeofenceAlerted(memberId);
          }
        }
      }
    });
  }

  stopListening() {
    locationUpdateTimer!.cancel();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
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
        body: Stack(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getPosition(), // TODO: Change
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
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserSOSPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        minimumSize: Size(100, 48),
                      ),
                      child: Text('SOS'),
                    ))),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return ElevatedButton(
                      onPressed: () {
                        developer.log('log me', name: 'my.app.category');
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 400,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Close')),
                                      ),
                                    ),
                                    BarcodeWidget(
                                        data:
                                            '000${ref.read(userProvider).currentUser!.id}',
                                        barcode: Barcode.code128(),
                                        width: 200,
                                        height: 200)
                                  ],
                                ),
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 3, 144, 8),
                        minimumSize: Size(100, 48),
                      ),
                      child: Text('Barcode'),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showCoordinates(lat, long) {
    return Text("Lat is $lat, Long is $long");
  }
}
