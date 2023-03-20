import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safezone_frontend/models/user.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';

class AppMap extends StatelessWidget {
  double initLat, initLong;
  Stream<dynamic>? locationsStream;
  AppMap(
      {required this.initLat,
      required this.initLong,
      required this.locationsStream});

  Marker buildLocationMarker(UserLocation userLocation) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(userLocation.lat, userLocation.lon),
      builder: (ctx) => Container(
          child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              width: 120,
              color: Colors.red,
              child: Center(
                child: Text(
                  userLocation.name,
                  style: const TextStyle(color: Colors.white),
                ),
              )),
          const Icon(
            Icons.location_on,
            color: Colors.red,
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: locationsStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          List<UserLocation> membersLocations = [];
          if (snapshot.hasData) {
            membersLocations =
                (json.decode(snapshot.data as String) as List<dynamic>)
                    .map((element) {
              print(element);
              final location = json.decode(element) as Map<String, dynamic>;
              return UserLocation(location["id"], location["name"],
                  location["lat"], location["lon"]);
            }).toList();

            print(membersLocations);
          }

          return FlutterMap(
            options: MapOptions(
                onTap: (p, l) async {},
                center: LatLng(initLat, initLong),
                zoom: 17.0,
                maxZoom: 17),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: membersLocations.isNotEmpty
                    ? membersLocations
                        .map((mLocation) => buildLocationMarker(mLocation))
                        .toList()
                    : [
                        buildLocationMarker(
                            UserLocation(0, "You", initLat, initLong))
                      ],
              ),
            ],
          );
        });
  }
}
