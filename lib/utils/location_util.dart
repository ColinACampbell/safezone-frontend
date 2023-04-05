import 'dart:convert';

import 'package:location/location.dart';
import 'package:safezone_frontend/models/user.dart';

class LocationTuple {
  final Location location;
  final LocationData locationData;

  LocationTuple(this.location, this.locationData);
}

class LocationUtil {

  Future<LocationData>? _initLocationData;
  Future<Location>? location;

  initLocationObject()
  {
    location ??= _getLocationObject();
  }

  Future<Location> _getLocationObject() async {
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

    _initLocationData ??= location.getLocation(); // if it's null, do assignment

    return location;
  }

  Future<LocationTuple> getLocation() async {
    //Location location = await getLocationObject();
    initLocationObject();
    var tuple = LocationTuple(await location!, (await _initLocationData)!);
    return tuple;
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

final locationUtil = LocationUtil();
