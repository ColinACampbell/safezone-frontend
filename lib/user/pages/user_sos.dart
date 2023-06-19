import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/providers.dart';

class UserSOSPage extends ConsumerWidget {
  const UserSOSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: ElevatedButton(
            onPressed: () {
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 10,
                      channelKey: 'safe_zone_key1',
                      title: "Sample notification",
                      body: "What is up"));
            },
            child: Text("Hellow world")));
  }
}
