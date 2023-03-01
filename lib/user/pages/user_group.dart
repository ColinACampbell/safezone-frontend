import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/app_text_field.dart';

class UserGroupPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomAppBar(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: AppTextField(hintText: "Search", onSaved: (val) {}),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, idx) {
                return Container(
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border.all(width: 1, color: Colors.black)),
                  height: 100,
                );
              }),
        )
      ],
    );
  }
}
