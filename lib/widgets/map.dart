import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AppMap extends StatelessWidget {
  double initLat, initLong;
  AppMap({required this.initLat, required this.initLong});

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
