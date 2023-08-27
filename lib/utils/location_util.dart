import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/utils.dart';
import 'package:safezone_frontend/utils/geo_locator.dart';
import 'package:safezone_frontend/utils/local_storage_util.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LocationTuple {
  final Location location;
  final LocationData locationData;

  LocationTuple(this.location, this.locationData);
}

class LocationUtil {
  // Future<LocationData>? _initLocationData;
  // Future<Location>? location;

  // initLocationObject()
  // {
  //   location ??= _getLocationObject();
  // }

  // Future<Location> _getLocationObject() async {
  //   Location location = Location();

  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       //return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       //return;
  //     }
  //   }

  //   _initLocationData ??= location.getLocation(); // if it's null, do assignment

  //   location.enableBackgroundMode(enable: true);

  //   return location;
  // }

  // Future<LocationTuple> getLocation() async {
  //   //Location location = await getLocationObject();
  //   initLocationObject();
  //   var tuple = LocationTuple(await location!, (await _initLocationData)!);
  //   return tuple;
  // }

  // getUserLocationData(User user, LocationData data) {
  //   return json.encode({
  //     "id": user.id,
  //     "name": user.firstname + " " + user.lastname,
  //     "lat": data.latitude,
  //     "lon": data.longitude
  //   });
  // }

  String getUserLocationDataFromCoords(User user, double lat, double long) {
    return json.encode({
      "id": user.id,
      "name": user.firstname + " " + user.lastname,
      "lat": lat,
      "lon": long
    });
  }
}

final locationUtil = LocationUtil();

Future<bool> streamLocationToServer() async {
  await requestGeoLocatorPermission();

  User? user = await localStorageUtil.getCurrentUserData();
  print("Trying to connect");
  print(user!.token!);
  IOWebSocketChannel? channel;
  bool connectionError = false;
  try {
    channel = await serverClient.connectToLocationsStreaming(user!.token!);
  } on Exception catch (e) {
    print(e.toString());
    connectionError = true;
    return Future.value(false);
  }

  channel.stream.listen((event) {
    print("Message from server is thread is....");
    print(event);
  }, onError: (ee) {
    print("Soo. the error is");
    print(ee);
  }, onDone: () {
    print("Soo. its just done now");
  });

  // ignore: avoid_print
  print("Connected to server!!");

  // For reference on the close code
  // https://pub.dev/documentation/web_socket_channel/latest/web_socket_channel/WebSocketChannel/closeCode.html

  while (true) {
    Position p = await Geolocator.getCurrentPosition();
    channel.sink.add(locationUtil.getUserLocationDataFromCoords(
        user, p.latitude, p.longitude));
    print("I have new positions -- From scheduled");
    // ignore: avoid_print
    print("${p.latitude} ${p.longitude}");

    sleep(const Duration(seconds: 3));
    // ignore: avoid_print

    if (channel.closeCode != null) {
      return Future.value(false);
    }
  }
}

Future<bool> streamLocationToServerViaWebHook() async {
  await requestGeoLocatorPermission();

  User? user = await localStorageUtil.getCurrentUserData();

  while (true) {
    Position p = await Geolocator.getCurrentPosition();
    // channel.sink.add(locationUtil.getUserLocationDataFromCoords(
    //     user, p.latitude, p.longitude));

    //final userLocationData = locationUtil.getUserLocationDataFromCoords(user, p.latitude, p.longitude);
    final isSuccess = await serverClient.callHook("update-location",{
      "id":user!.id,
      "lat":p.latitude,
      "lon":p.longitude,
      "name":"${user.firstname} ${user.lastname}"
    }, user.token!);
    print("Send location via hook is $isSuccess");

    // ignore: avoid_print
    print("I have new positions -- From Webhoot");
    // ignore: avoid_print
    print("${p.latitude} ${p.longitude}");

    sleep(const Duration(seconds: 3));

  }
}