import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 63,
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back)),
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle))
        ],
      ),
    );
  }
}
