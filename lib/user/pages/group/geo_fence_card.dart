import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/user/pages/group/show_geo_fence_map.dart';

class GeofenceCard extends StatelessWidget {
  final GeoRestriction _restriction;
  final bool isLastCard;
  const GeofenceCard(this._restriction, {Key? key, required this.isLastCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: placemarkFromCoordinates(
            _restriction.latitude, _restriction.longitude),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Placemark> placemarks = snapshot.data as List<Placemark>;
            String? locationName = "";
            if (placemarks.isNotEmpty) {
              locationName = placemarks[0].name;
            }

            // ignore: prefer_conditional_assignment
            if (locationName == null) {
              locationName =
                  "${_restriction.latitude} ${_restriction.longitude}";
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowGeoFenceScreen(_restriction)));
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: !isLastCard
                    ? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: .5)))
                    : null,
                child: Row(
                  children: [
                    const Icon(Icons.location_city),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locationName!,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "${_restriction.radius.round() * 2} meters wide",
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
          } else {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [const Text("Please wait, fetching location name")],
            );
          }
        });
  }
}
