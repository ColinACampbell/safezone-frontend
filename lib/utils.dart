import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safezone_frontend/user/pages/group/add_geo_fence.dart';
import 'package:safezone_frontend/user/pages/group/group_confidants.dart';
import 'package:safezone_frontend/user/pages/group/user_group.dart';
import 'package:safezone_frontend/user/pages/medical_record/user_medical_records.dart';
import 'package:safezone_frontend/user/pages/user_login.dart';
import 'package:http/http.dart' as http;
import 'package:safezone_frontend/models/exception.dart';
import 'package:safezone_frontend/user/pages/user_tab.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const accentColor =  Color.fromRGBO(233, 69, 96, 1);
const primaryColor = Colors.blue;


Map<String, WidgetBuilder> appRoutes = {
  UserLoginPage.route_name: (context) => UserLoginPage(),
  UserTabPage.route_name: (context) => UserTabPage(),
  UserGroupPage.routeName: (context) => UserGroupPage(),
  GroupConfidants.routeName: (context) => GroupConfidants(),
  AddGeoFenceScreen.routeName : (context) => AddGeoFenceScreen(),
  UserMedicalRecordsScreen.routeName : (context) => UserMedicalRecordsScreen()
};

// TODO: Convert to singleton
// TODO: Build headers
class ServerClient {
  final httpClient = http.Client();
  final baseURl = "localhost";
  late String apiURL, socketURL;

  final header = {};

  ServerClient() {
    apiURL = "http://$baseURl:8080";
    socketURL = "ws://$baseURl:8080";
  }

  buildHeaders({String? token}) {
    final header = {
      "content-type": "application/json",
    };
    if (token != null) {
      header["Authorization"] = "Bearer $token";
    }
    return header;
  }

  WebSocketChannel joinGroupSocketRoom(int groupId) {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://$baseURl:8080/group/$groupId'),
    );

    return channel;
  }

  WebSocketChannel connectToLocationsStreaming(String userToken) {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://$baseURl:8080/stream-group-locations/$userToken'),
    );
    return channel;
  }

  // Gets all the locations from all the user's mutual members
  WebSocketChannel connectToMembersLocationUpdates(String userToken) {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://$baseURl:8080/get-group-locations/$userToken'),
    );
    return channel;
  }

  Future<dynamic> post(String endPoint, Map<String, dynamic> body,
      {String? token}) async {
    var resp = await httpClient.post(
      Uri.parse("$apiURL$endPoint"),
      headers: buildHeaders(token: token),
      body: json.encode(body),
    );

    if (resp.statusCode >= 400) {
      // ignore: avoid_print
      print(resp.body);
      throw APIExecption(json.decode(resp.body)['detail']);
    }
    return jsonDecode(resp.body);
  }

  Future<dynamic> get(String endPoint, {String? token}) async {
    var resp = await httpClient.get(
      Uri.parse("$apiURL$endPoint"),
      headers: buildHeaders(token: token),
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
