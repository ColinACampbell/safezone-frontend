import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  Function() onTap;
  double width;
  String text;
  AppButton({required this.onTap, required this.text, this.width = 182});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        width: width,
        decoration: const BoxDecoration(
            color: const Color.fromRGBO(233, 69, 96, 1),
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        height: 50,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
