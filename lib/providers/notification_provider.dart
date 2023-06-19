import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/providers/user_provider.dart';

class NotificationProvider extends ChangeNotifier {
  final UserProvider _userProvider;
  Map<int, bool> geoFenceFlags = {};
  Map<int, UserLocation?> membersLocations = {};
  NotificationProvider(this._userProvider);

  void processLocations(List<UserLocation> locations) async {
    for (int i = 0; i < locations.length; i++) {
      var location = locations[i];

      membersLocations[location.id] = location;

      if (!geoFenceFlags.containsKey(location.id) &&
          _userProvider.currentUser!.id != location.id) { // if the location isn't flagged for geofence violation, and the user isn't the current user flag them for notification
        geoFenceFlags[location.id] = true;
      }
    }
    notifyListeners();
  }

  void markGeofenceAlerted(int userId) {
    geoFenceFlags[userId] = false;
    notifyListeners();
  }
}
