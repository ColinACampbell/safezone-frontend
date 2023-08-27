import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safezone_frontend/models/group.dart';

class ShowGeoFenceScreen extends StatelessWidget {
  final GeoRestriction _restriction;
  const ShowGeoFenceScreen(this._restriction);

  @override
  Widget build(BuildContext context) {
    final circularMarker = CircleMarker(
        point: LatLng(_restriction.latitude, _restriction.longitude),
        radius: _restriction.radius,
        useRadiusInMeter: true,
        borderColor: const Color.fromRGBO(200, 3, 3, .9),
        borderStrokeWidth: 1,
        color: const Color.fromRGBO(200, 200, 200, .5));
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    onMapCreated: (controlelr) {},
                    center:
                        LatLng(_restriction.latitude, _restriction.longitude),
                    zoom: 17.0,
                    maxZoom: 17,
                    minZoom: 17,
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    CircleLayerOptions(circles: [circularMarker])
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
