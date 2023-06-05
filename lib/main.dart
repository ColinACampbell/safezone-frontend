import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/user_login.dart';
import 'package:safezone_frontend/user/pages/user_tab.dart';
import 'package:safezone_frontend/utils.dart';
import 'package:safezone_frontend/utils/geo_locator.dart';
import 'package:safezone_frontend/utils/local_storage_util.dart';
import 'package:safezone_frontend/utils/location_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((String task, inputData) async {
    DartPluginRegistrant.ensureInitialized();
    if (task == "BACKGROUND_UPDATE_2") {
      User? user = await localStorageUtil.getCurrentUserData();
      print(user!.token!);
      WebSocketChannel channel =
          serverClient.connectToLocationsStreaming(user!.token!);

      // ignore: avoid_print
      print("Connected to server!!");

      await requestGeoLocatorPermission();

      // For reference on the close code
      // https://pub.dev/documentation/web_socket_channel/latest/web_socket_channel/WebSocketChannel/closeCode.html

      Position p = await Geolocator.getCurrentPosition();

      // ignore: avoid_print
      print("I have new positions -- From scheduled");
      // ignore: avoid_print
      print("${p.latitude} ${p.longitude}");
      channel.sink.add(locationUtil.getUserLocationDataFromCoords(
          user, p.latitude, p.longitude));

      channel.sink.close();
      print("Ending connection to server");
      // ignore: avoid_print
      print(channel.closeReason);
    } 
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
      home: FutureBuilder(builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? currentUser = snapshot.data as User?;
          if (currentUser == null) {
            return UserLoginPage();
          } else {
            ref.read(userProvider).setCurrentUser = currentUser;
            return UserTabPage();
          }
        } else {
          return UserLoginPage();
        }
      }),
    );
  }
}
