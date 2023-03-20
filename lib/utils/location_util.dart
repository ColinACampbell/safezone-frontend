import 'dart:convert';

import 'package:location/location.dart';
import 'package:safezone_frontend/models/user.dart';

class LocationTuple {
  final Location location;
  final LocationData locationData;

  LocationTuple(this.location, this.locationData);
}

class _LocationUtil {
  Future<Location> getLocationObject() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        //return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        //return;
      }
    }

    return location;
  }

  Future<LocationTuple> getLocation() async {
    Location location = await getLocationObject();
    return LocationTuple(location, (await location.getLocation()));
  }

  getUserLocationData(User user, LocationData data) {
    return json.encode({
      "id": user.id,
      "name": user.firstname + " " + user.lastname,
      "lat": data.latitude,
      "lon": data.longitude
    });
  }
}

final locationUtil = _LocationUtil();
