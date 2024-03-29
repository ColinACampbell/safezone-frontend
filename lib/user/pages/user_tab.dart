import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/exception.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/group/user_groups.dart';
import 'package:safezone_frontend/user/pages/user_home.dart';
import 'package:safezone_frontend/user/pages/user_sos.dart';
import 'package:safezone_frontend/widgets/app_button.dart';
import 'package:safezone_frontend/widgets/app_text_field.dart';

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
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    Future.delayed(Duration.zero, () async {});
  }

  List<Widget> screens = [
    UserHomePage(),
    const UserGroupsPage(),
    UserSOSPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIdx],
      floatingActionButton: screens[currentIdx] is UserGroupsPage
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                // TODO : Apply dry
                showModalBottomSheet(
                    isScrollControlled:
                        true, // take up the full height required
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    context: context,
                    builder: (context) {
                      return buildCreateGroupBottomSheetModal();
                    });
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIdx,
          onTap: (index) {
            setState(() {
              if (screens[index] is! UserHomePage) {
                screens[0] = const UserHomePage();
              }
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

  // https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
  Widget buildCreateGroupBottomSheetModal() {
    String groupName = "";
    final _form = GlobalKey<FormState>();

    return Container(
      //padding: const EdgeInsets.all(15),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          left: 10,
          top: 10,
          right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
              key: _form,
              child: AppTextField(
                  hintText: "Enter Group Name",
                  autoFocus: true,
                  onSaved: (val) {
                    groupName = val!;
                  })),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                    child: AppButton(
                  text: "Create Group",
                  onTap: () async {
                    _form.currentState!.save();
                    try {
                      await ref.read(groupsProvider).createGroup(groupName);
                      Navigator.pop(context);
                    } on APIExecption catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.message)));
                    }
                  },
                  width: 100,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
