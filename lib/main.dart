import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/user/pages/user_login.dart';
import 'package:safezone_frontend/utils.dart';

void main() {
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.bottom]);
  runApp(ProviderScope(child: App()));
}

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//             child: TextButton(
//           onPressed: () async {
//             Position position = await Geolocator.getCurrentPosition(
//                 desiredAccuracy: LocationAccuracy.high);
//             print("${position.latitude}, ${position.longitude}");
//           },
//           child: const Text("Hello World"),
//         )),
//       ),
//     );
//   }
// }

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: appRoutes,
      initialRoute: UserLoginPage.route_name,
    );
  }
}
