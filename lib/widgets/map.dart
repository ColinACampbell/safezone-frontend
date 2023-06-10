import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:safezone_frontend/main.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/providers/providers.dart';

class AppMap extends ConsumerStatefulWidget {
  double initLat, initLong;
  Stream<dynamic>? locationsStream;
  void Function(void)? onMapTap;
  AppMap(
      {required this.initLat,
      required this.initLong,
      required this.locationsStream,
      onMapTap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AppMapState();
  }
}

class _AppMapState extends ConsumerState<AppMap> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      // Listen out for geo restriction violation
      widget.locationsStream!.asBroadcastStream().listen((event) {
        var membersLocations =
            (json.decode(event as String) as List<dynamic>).map((element) {
          final location = json.decode(element) as Map<String, dynamic>;
          return UserLocation(location["id"], location["name"], location["lat"],
              location["lon"],
              geoFlag: location['geo_flag'],
              geoFenceDistance: location['geo_fence_distance']);
        }).toList();
        ref.watch(notificationProvider).processLocations(membersLocations);
      });
    });
  }

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
        stream: widget.locationsStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          List<UserLocation> membersLocations = [];
          if (snapshot.hasData) {
            membersLocations =
                (json.decode(snapshot.data as String) as List<dynamic>)
                    .map((element) {
              final location = json.decode(element) as Map<String, dynamic>;
              return UserLocation(location["id"], location["name"],
                  location["lat"], location["lon"],
                  geoFlag: location['geo_flag'],
                  geoFenceDistance: location['geo_fence_distance']);
            }).toList();
          }

          return FlutterMap(
            options: MapOptions(
                onTap: (p, l) async {
                  print(p.global.dy);
                },
                center: LatLng(widget.initLat, widget.initLong),
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
                        buildLocationMarker(UserLocation(
                            0, "You", widget.initLat, widget.initLong))
                      ],
              ),
            ],
          );
        });
  }
}
