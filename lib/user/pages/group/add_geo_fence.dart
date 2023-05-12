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
  double pointWidth = 10;
  double scaledWidth = 0;
  double zoomLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      scaledWidth = calcScaledWidth(pointWidth, 17);
      print(scaledWidth);
      zoomLevel = 17;
    });
  }

  double calcScaledWidth(double pWidth, double scale) {
    return (scale * pWidth) / 17;
  }

  double metersPerPixel(double latitude, double zoom) {
     //return (156543.03392 *
     //    math.cos(latitude * math.pi / 180) /
     //    math.pow(3,zoom));
    return 40075016.686 * (math.cos(latitude * math.pi/180)) / math.pow(2,zoom+8).abs();


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
              //borderRadius: BorderRadius.all(Radius.circular(100))
            ),
          );
        });
    setState(() {
      geoFenceMarkers.add(marker);
      print("Added marker witd with $size");
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
                color: Color.fromRGBO(255, 0, 0, .9),
                shape: BoxShape.circle
                ),
          );
        });
  }

  void lat_from_distance(double latitude, distance) {
    var earth = 6378.137, //radius of the earth in kilometer
        pi = math.pi,
        m = (1 / ((2 * pi / 360) * earth)) / 1000; //1 meter in degree

    var new_latitude = latitude + (distance * m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlutterMap(
            options: MapOptions(
              onMapCreated: (controlelr) {},
              onPositionChanged: ((position, hasGesture) {
                zoomLevel = position.zoom!;
                if (geoFenceMarkers.isNotEmpty) {
                  setState(() {
                    scaledWidth = calcScaledWidth(pointWidth, position.zoom!);

                    for (int i = 0; i < geoFenceMarkers.length; i++) {
                      var oldMarker = geoFenceMarkers[i];
                      geoFenceMarkers[i] =
                          createMarker(oldMarker.point, scaledWidth);
                    }

                    //Marker oldM = geoFenceMarkers.removeAt(0);
                    //addMarker(oldM.point, scaledWidth);
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
            ],
          ),
          ElevatedButton(
              onPressed: () {
                if (geoFenceMarkers.length == 2) {
                  Marker m1 = geoFenceMarkers[0];
                  Marker m2 = geoFenceMarkers[1];

                  double distance = getDistanceFromLatLonInKm(
                      m1.point.latitude,
                      m1.point.longitude,
                      m2.point.latitude,
                      m2.point.longitude) * 1000; 

                  print("Zoom level is $zoomLevel");
                  final ratio = metersPerPixel(m1.point.latitude, zoomLevel);
                  print("Ratio is $ratio");
                  print("Distance is $distance");
                  print("Pixel size is ${(distance) / ratio}");
                  setState(() {
                    geoFenceMarkers[0] =
                        createMarker(m1.point, (distance * ratio) + (200 * ratio)  );
                  });
                }
              },
              child: const Text("Hello World"))
        ],
      ),
    );
  }
}
