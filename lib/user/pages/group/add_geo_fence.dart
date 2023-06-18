import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:safezone_frontend/models/exception.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/models/user.dart';
import 'dart:math' as math;
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/widgets/map.dart';

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
  double radiusInMeters = 0;
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
    Marker marker = createMarker(l, size);
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
                color: Color.fromRGBO(0, 0, 250, .9), shape: BoxShape.circle),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final routeInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final group = routeInfo['group'] as Group;
    final user = routeInfo['user'] as User;

    final notificationContainer = ref.watch(notificationProvider);
    var userLocation = notificationContainer.membersLocations[user.id];

    //final broadcast = groupContainer.groupConnections[group.id]!;

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isCirclePresent)
            FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () {
                  buildAddTimeDialog(context, user, group);
                }),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
              onPressed: () {
                if (geoFenceMarkers.length == 2) {
                  Marker m1 = geoFenceMarkers[0];
                  Marker m2 = geoFenceMarkers[1];

                  setState(() {
                    radiusInMeters = getDistanceFromLatLonInKm(
                            m1.point.latitude,
                            m1.point.longitude,
                            m2.point.latitude,
                            m2.point.longitude) *
                        1000;

                    var newCircle = CircleMarker(
                        point: m1.point,
                        radius: radiusInMeters,
                        useRadiusInMeter: true,
                        borderColor: const Color.fromRGBO(200, 3, 3, .9),
                        borderStrokeWidth: 1,
                        color: const Color.fromRGBO(200, 200, 200, .5));
                    if (circleMarkers.length == 0) {
                      circleMarkers.add(newCircle);
                    } else {
                      circleMarkers[0] = newCircle;
                    }

                    isCirclePresent = true;
                  });
                }
              },
              child: const Icon(Icons.add)),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                geoFenceMarkers.clear();
                circleMarkers.clear();
                isCirclePresent = false;
              });
            },
            child: const Icon(Icons.delete),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FutureBuilder(
                    future: Geolocator.getCurrentPosition(),
                    builder: (context, snapshot) {
                      double initLat = 0;
                      double initLong = 0;
                      if (snapshot.hasData) {
                        Position p = snapshot.data as Position;
                        initLat = p.latitude;
                        initLong = p.longitude;
                        return FlutterMap(
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

                                  for (int i = 0;
                                      i < geoFenceMarkers.length;
                                      i++) {
                                    var oldMarker = geoFenceMarkers[i];
                                    geoFenceMarkers[i] = createMarker(
                                        oldMarker.point, scaledWidth);
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
                            center: LatLng(initLat, initLong),
                            zoom: 17.0,
                            maxZoom: 17,
                          ),
                          layers: [
                            TileLayerOptions(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c']),
                            MarkerLayerOptions(markers: [
                              ...geoFenceMarkers,
                              if (userLocation !=
                                  null) // show the user location on the map if they location is saved in the system
                                buildLocationMarker(userLocation)
                            ]),
                            CircleLayerOptions(circles: circleMarkers)
                          ],
                        );
                      } else {
                        return const Text(
                            "Pleasee wait, fetching your location");
                      }
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  int convertToUTC(int hour, int offset) {
    // Calculate the adjusted hour in UTC
    print(hour);
    print(offset);
    int utcHour = (hour - offset) % 24;
    if (utcHour < 0) {
      utcHour += 24;
    }

    // Return the UTC hour
    return utcHour;
  }

  int fromTime = -1;
  int toTime = -1;
  TimeOfDay? selectedFromTime;
  TimeOfDay? selectedToTime;
  buildAddTimeDialog(BuildContext context, User user, Group group) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Geofence'),
          content: StatefulBuilder(builder: (context, setState) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    selectedFromTime == null
                        ? const Text("Select From Hour")
                        : Text(
                            "${selectedFromTime!.hour}:${selectedFromTime!.minute}"),
                    TextButton(
                        onPressed: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            setState(() {
                              selectedFromTime = value;
                              fromTime = selectedFromTime!.hour;
                            });
                          });
                        },
                        child: Text("Select Time"))
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    toTime == -1
                        ? Text("Select To Hour")
                        : Text(
                            "${selectedToTime!.hour}:${selectedToTime!.minute}"),
                    TextButton(
                        onPressed: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            setState(() {
                              selectedToTime = value;
                              toTime = selectedToTime!.hour;
                            });
                          });
                        },
                        child: Text("Select Time"))
                  ])
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Sumbit'),
              onPressed: () {
                var centerMarker = geoFenceMarkers[0];
                try {
                  var now = DateTime.now();
                  var timezoneOffset = now.timeZoneOffset.inHours;
                  ref.read(groupsProvider).geofenceUser(
                      group.id,
                      user.id,
                      centerMarker.point.latitude,
                      centerMarker.point.longitude,
                      radiusInMeters,
                      convertToUTC(fromTime, timezoneOffset),
                      convertToUTC(toTime,
                          timezoneOffset)); // convert the time to utc on submit
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(" ${user.email} geofenced successfully")));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } on APIExecption catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
