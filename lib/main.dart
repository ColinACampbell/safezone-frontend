import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/user.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/user_login.dart';
import 'package:safezone_frontend/user/pages/user_tab.dart';
import 'package:safezone_frontend/utils.dart';

void main() {
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
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
