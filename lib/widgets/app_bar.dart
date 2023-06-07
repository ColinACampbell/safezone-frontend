import 'package:flutter/material.dart';
import 'package:safezone_frontend/user/pages/medical_record/user_medical_records.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  IconButton? iconButton;
  CustomAppBar({Key? key, required this.title, this.iconButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 63,
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          iconButton != null
              ? iconButton!
              : IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(UserMedicalRecordsScreen.routeName);
                  },
                  icon: const Icon(Icons.account_circle))
        ],
      ),
    );
  }
}
