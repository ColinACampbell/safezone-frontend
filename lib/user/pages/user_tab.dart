import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTabPage extends ConsumerWidget {
  static const String route_name = "/user_tab_page";
  const UserTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const Center(child: Text("Welcome Colin")),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Groups"),
        BottomNavigationBarItem(icon: Icon(Icons.phone_locked), label: "SOS")
      ]),
    );
  }
}
