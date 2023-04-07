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
  double pointWidth = 50;
  double scaledWidth = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      scaledWidth = calcScaledWidth(pointWidth, 17);
      print(scaledWidth);
    });
  }

  double calcScaledWidth(double pWidth, double scale) {
    return (scale * pWidth) / 17;
  }

  void addMarker(LatLng l, double size) {
    Marker marker = Marker(
        width:size,
        height: size,
        point: LatLng(l.latitude, l.longitude),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 0, 0, .9),
              borderRadius: BorderRadius.all(Radius.circular(100))
            ),
            
          );
        });
    setState(() {
      geoFenceMarkers.add(marker);
      print("Added marker witd with $size");
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
                print("Changed");
                print(position.zoom!);
                if (geoFenceMarkers.isNotEmpty) {
                  setState(() {
                    scaledWidth = calcScaledWidth(pointWidth, position.zoom!);
                    Marker oldM = geoFenceMarkers.removeAt(0);
                    addMarker(oldM.point, scaledWidth);
                  });
                }
              }),
              onTap: (p, l) async {
                if (geoFenceMarkers.isNotEmpty) {
                  geoFenceMarkers.removeAt(0);
                }
                addMarker(l, scaledWidth);
              },
              center: LatLng(0, 0),
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
        ],
      ),
    );
  }
}
