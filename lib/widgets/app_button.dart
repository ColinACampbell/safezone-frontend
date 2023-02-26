import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  Function() onTap;
  double width;
  AppButton({required this.onTap, this.width = 182});

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
        child: const Center(
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
