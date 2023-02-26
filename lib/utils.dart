import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safezone_frontend/user/pages/user_login.dart';
import 'package:http/http.dart' as http;
import 'package:safezone_frontend/models/exception.dart';

Map<String, WidgetBuilder> appRoutes = {
  UserLoginPage.ROUTE_NAME: (context) => UserLoginPage(),
};

// TODO: Convert to singleton
class ServerClient {
  final httpClient = http.Client();
  final apiURL = "http://192.168.100.195:8080";
  final header = {};

  Future<Map<String, dynamic>> post(
      String endPoint, Map<String, dynamic> body) async {
    var resp = await httpClient.post(
      Uri.parse("$apiURL$endPoint"),
      headers: {
        "content-type": "application/json",
        //"Accept": "application/json"
      },
      body: json.encode(body),
    );

    if (resp.statusCode >= 400) {
      // ignore: avoid_print
      print(resp.body);
      throw APIExecption(json.decode(resp.body)['detail']);
    }
    return jsonDecode(resp.body);
  }
}

final serverClient = ServerClient();
