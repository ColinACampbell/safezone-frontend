import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class AddGeoFenceScreen extends ConsumerStatefulWidget {
  static const String routeName = "/group_add_geofence_screen";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddGeoFenceScreenState();
  }
}

class _AddGeoFenceScreenState extends ConsumerState {
  List<Marker> geoFenceMarkers = [];
  List<CircleMarker> circleMarkers = [];
  double pointWidth = 10;
  double scaledWidth = 0;
  double zoomLevel = 0;
  bool isCirclePresent = false; // todo: Implement

  @override
  void initState() {
    super.initState();
    setState(() {
      scaledWidth = calcScaledWidth(pointWidth, 17);
      zoomLevel = 17;
    });
  }

  // Scales the width of the marker on the map based of the zoom level
  double calcScaledWidth(double pWidth, double scale) {
    return (scale * pWidth) / 17;
  }

  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (math.pi / 180);
  }

  void addMarker(LatLng l, double size) {
    Marker marker = Marker(
        width: size,
        height: size,
        point: LatLng(l.latitude, l.longitude),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 0, 0, .9),
            ),
          );
        });
    setState(() {
      geoFenceMarkers.add(marker);
      print("Added marker with $size");
    });
  }

  Marker createMarker(LatLng l, double size) {
    return Marker(
        width: size,
        height: size,
        point: LatLng(l.latitude, l.longitude),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 0, 0, .9), shape: BoxShape.circle),
          );
        });
  }

  // TODO: Remove
  // void lat_from_distance(double latitude, distance) {
  //   var earth = 6378.137, //radius of the earth in kilometer
  //       pi = math.pi,
  //       m = (1 / ((2 * pi / 360) * earth)) / 1000; //1 meter in degree

  //   var new_latitude = latitude + (distance * m);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
          onPressed: () {
            if (geoFenceMarkers.length == 2) {
              Marker m1 = geoFenceMarkers[0];
              Marker m2 = geoFenceMarkers[1];

              double distanceInMeters = getDistanceFromLatLonInKm(
                      m1.point.latitude,
                      m1.point.longitude,
                      m2.point.latitude,
                      m2.point.longitude) *
                  1000;

              setState(() {
                var newCircle = CircleMarker(
                    point: m1.point,
                    radius: distanceInMeters,
                    useRadiusInMeter: true,
                    color: const Color.fromRGBO(200, 200, 200, .5));
                if (circleMarkers.length == 0) {
                  circleMarkers.add(newCircle);
                } else {
                  circleMarkers[0] = newCircle;
                }
              });
            }
          },
          child: const Icon(Icons.add)),
          const SizedBox(height: 20),
          FloatingActionButton(onPressed: (){}, child: const Icon(Icons.delete),)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    onMapCreated: (controlelr) {},
                    onPositionChanged: ((position, hasGesture) {
                      zoomLevel = position.zoom!;
                      if (geoFenceMarkers.isNotEmpty) {
                        setState(() {
                          scaledWidth = calcScaledWidth(
                              pointWidth,
                              position
                                  .zoom!); // anytime the zoom changes we want to change the ratio of the zoom on the screen

                          for (int i = 0; i < geoFenceMarkers.length; i++) {
                            var oldMarker = geoFenceMarkers[i];
                            geoFenceMarkers[i] =
                                createMarker(oldMarker.point, scaledWidth);
                          }
                        });
                      }
                    }),
                    onTap: (p, l) async {
                      if (geoFenceMarkers.length < 2) {
                        addMarker(l, scaledWidth);
                      } else if (geoFenceMarkers.length == 2) {
                        geoFenceMarkers.removeLast();
                        addMarker(l, scaledWidth);
                      }
                    },
                    center: LatLng(17.898418, -76.906672),
                    zoom: 17.0,
                    maxZoom: 17,
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    MarkerLayerOptions(markers: geoFenceMarkers),
                    CircleLayerOptions(circles: circleMarkers)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
