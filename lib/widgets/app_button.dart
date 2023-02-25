import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 182,
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
