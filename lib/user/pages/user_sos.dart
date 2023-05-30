import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/providers/providers.dart';

class UserSOSPage extends ConsumerWidget {
  const UserSOSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 30),
            child: Image(image: AssetImage('assets/phone_sos.png')))
      ],
    ));
  }
}
