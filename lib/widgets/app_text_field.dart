import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  bool isPassword = false;

  AppTextField({Key? key, required this.hintText, this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromRGBO(137, 137, 137, 1)),
          fillColor: const Color.fromRGBO(223, 223, 223, 1)),
      obscureText: isPassword,
    );
  }
}
