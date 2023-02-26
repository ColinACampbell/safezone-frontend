import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/exception.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/widgets/app_button.dart';
import 'package:safezone_frontend/widgets/app_text_field.dart';

// TODO : Add form validation
class CustomerLoginPage extends ConsumerWidget {
  static final String ROUTE_NAME = "/customer_login";
  final _loginFormKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
        body: Center(
      child: Container(
          width: MediaQuery.of(context).size.width * .70,
          height: MediaQuery.of(context).size.height * .90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          .075, // let it be variable
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 50, bottom: 50),
                      child: const Text(
                        "Safe Zone",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: const Text("Login",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: const Text("Hey, Welcome back",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    AppTextField(
                      hintText: "Email",
                      onSaved: (String? val) {
                        email = val!;
                      },
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      hintText: "Password",
                      isPassword: true,
                      onSaved: (String? val) {
                        password = val!;
                      },
                    ),
                    const SizedBox(height: 24),
                    AppButton(onTap: () async {
                      _loginFormKey.currentState!.save();
                      try {
                        await ref.read(userProvider).login(email, password);
                      } on APIExecption catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(e.message)));
                      }
                    })
                  ],
                ),
              ),
              Container(
                child: const Text("Don't have an account? Sign up"),
              )
            ],
          )),
    ));
  }
}