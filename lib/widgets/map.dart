import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';

class AppMap extends StatelessWidget {
  double initLat, initLong;
  AppMap({required this.initLat, required this.initLong});

  @override
  Widget build(BuildContext context) {
    print(initLat);
    print(initLong);

    return FlutterMap(
      options: MapOptions(
          onTap: (p, l) async {},
          center: LatLng(initLat, initLong),
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
              point: LatLng(initLat, initLong),
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
  }
}
