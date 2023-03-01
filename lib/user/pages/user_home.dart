import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);
  @override
  State<UserHomePage> createState() => _MapViewState();
}

class _MapViewState extends State<UserHomePage> {
  double _lat = 0;
  double _long = 0;

  @override
  void initState() {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080/group/ss'),
    );

    channel.stream.listen((event) {
      print(event as String);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            FutureBuilder(
              future: _determinePosition(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Position pos = snapshot.data as Position;
                  return Expanded(
                      child:
                          Map(initLat: pos.latitude, initLong: pos.longitude));
                } else {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                    width: MediaQuery.of(context).size.width * .23,
                    height: MediaQuery.of(context).size.width * .23,
                  );
                }
              },
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

class Map extends StatelessWidget {
  double initLat, initLong;
  Map({required this.initLat, required this.initLong});

  @override
  Widget build(BuildContext context) {
    print(initLat);
    print(initLong);

    return StreamBuilder(builder: (context, snapshot) {
      double long, lat;
      if (snapshot.hasData) {
        Position pos = snapshot.data as Position;
        long = pos.longitude;
        lat = pos.latitude;
        print(lat);
        print(long);
      } else {
        long = initLong;
        lat = initLat;
      }
      return FlutterMap(
        options: MapOptions(
            onTap: (p, l) async {},
            center: LatLng(lat, long),
            zoom: 17.0,
            maxZoom: 17),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(lat, long),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ],
      );
    });
  }
}
