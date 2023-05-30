import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/exception.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/providers/user_provider.dart';
import 'package:safezone_frontend/user/pages/user_tab.dart';
import 'package:safezone_frontend/utils/geo_locator.dart';
import 'package:safezone_frontend/utils/location_util.dart';
import 'package:safezone_frontend/widgets/app_button.dart';
import 'package:safezone_frontend/widgets/app_text_field.dart';
import 'package:workmanager/workmanager.dart';

// TODO : Add form validation
class UserLoginPage extends ConsumerStatefulWidget {
  static const String route_name = "/customer_login";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends ConsumerState<UserLoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String firstName = "";
  String lastName = "";
  bool isInLoginState = true;

  @override
  void initState() {
    super.initState();
    requestGeoLocatorPermission();
  }

  Widget loginForm(context, WidgetRef ref) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          SizedBox(
            height:
                MediaQuery.of(context).size.height * .075, // let it be variable
          ),
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: const Text(
              "Safe Zone",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: const Text("Login",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500))),
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text("Hey, Welcome back",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
          AppButton(
              text: "Login",
              onTap: () async {
                _loginFormKey.currentState!.save();
                try {
                  await ref.read(userProvider).login(email, password);
                  await ref
                     .read(userProvider)
                     .connectToGeneralLocationsStreaming(); // join the stream to get all the locations
                  Workmanager().cancelByUniqueName("BACKGROUND_UPDATE"); // stop the task, then listen
                  Workmanager().registerOneOffTask("BACKGROUND_UPDATE", "BACKGROUND_UPDATE");
                  Navigator.of(context).popAndPushNamed(UserTabPage.route_name);
                } on APIExecption catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                }
              })
        ],
      ),
    );
  }

  Widget signUpForm(context, WidgetRef ref) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          SizedBox(
            height:
                MediaQuery.of(context).size.height * .075, // let it be variable
          ),
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: const Text(
              "Safe Zone",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text("Sign Up",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text("Hey, Welcome",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AppTextField(
            hintText: "First Name",
            onSaved: (String? val) {
              firstName = val!;
            },
          ),
          const SizedBox(height: 24),
          AppTextField(
            hintText: "Last Name",
            onSaved: (String? val) {
              lastName = val!;
            },
          ),
          const SizedBox(height: 24),
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
          AppButton(
              text: "Sign up",
              onTap: () async {
                _loginFormKey.currentState!.save();
                try {
                  await ref
                      .read(userProvider)
                      .signup(firstName, lastName, email, password);
                  await ref
                      .read(userProvider)
                      .connectToGeneralLocationsStreaming(); // join the stream to get all the locations
                  Navigator.of(context).popAndPushNamed(UserTabPage.route_name);
                } on APIExecption catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                }
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          width: MediaQuery.of(context).size.width * .70,
          height: MediaQuery.of(context).size.height * .90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isInLoginState
                  ? loginForm(context, ref)
                  : signUpForm(context, ref),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isInLoginState = !isInLoginState;
                      });
                    },
                    child: const Text("Sign up"),
                  ),
                ],
              )),
            ],
          )),
    ));
  }
}
