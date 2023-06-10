import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/providers/user_provider.dart';

class NotificationProvider extends ChangeNotifier {
  UserProvider _userProvider;
  Map<int, bool> geoFenceFlags = {};
  NotificationProvider(this._userProvider);

  void processLocations(List<UserLocation> locations) {
    for (int i = 0; i < locations.length; i++) {
      var location = locations[i];
      if (location.geoFlag &&
          !geoFenceFlags.keys.toList().contains(location.id)) {
        print("User Geo Restriction violation found");
        geoFenceFlags[location.id] = true;
      }
    }
  }
}
