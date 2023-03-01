import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/user/pages/user_group.dart';
import 'package:safezone_frontend/user/pages/user_home.dart';
import 'package:safezone_frontend/user/pages/user_sos.dart';

class UserTabPage extends ConsumerStatefulWidget {
  static const String route_name = "/user_tab_page";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserTabPageState();
  }
}

class UserTabPageState extends ConsumerState {
  int currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const UserHomePage(),
      UserGroupPage(),
      UserSOSPage()
    ];

    return Scaffold(
      body: screens[currentIdx],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIdx,
          onTap: (index) {
            setState(() {
              currentIdx = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Groups"),
            BottomNavigationBarItem(
                icon: Icon(Icons.phone_locked), label: "SOS")
          ]),
    );
  }
}
