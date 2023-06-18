import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/providers/user_provider.dart';

class NotificationProvider extends ChangeNotifier {
  UserProvider _userProvider;
  Map<int, bool> geoFenceFlags = {};
  Map<int, UserLocation?> membersLocations = {};
  NotificationProvider(this._userProvider);

  void processLocations(List<UserLocation> locations) async {
    for (int i = 0; i < locations.length; i++) {
      var location = locations[i];

      if (!membersLocations.containsKey(location.id))
      {
        membersLocations[location.id] = locations[i];
      }

      if (location.geoFlag &&
          !geoFenceFlags.keys.toList().contains(location.id) &&
          location.id != _userProvider.currentUser!.id) {
        print("-------User Geo Restriction violation found------");

        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('app_icon');
        final DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          onDidReceiveLocalNotification: (val, val1, val2, val5) {},
        );

        const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails('19298384', 'Safezone Channel',
                channelDescription: 'My Description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker');
        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
            0, 'plain title', 'plain body', notificationDetails,
            payload: 'item x');

        geoFenceFlags[location.id] = true;
      }
    }
    notifyListeners();
  }
}
