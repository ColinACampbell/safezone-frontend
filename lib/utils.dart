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
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const accentColor = Color.fromRGBO(233, 69, 96, 1);
const primaryColor = Colors.blue;

Map<String, WidgetBuilder> appRoutes = {
  UserLoginPage.route_name: (context) => UserLoginPage(),
  UserTabPage.route_name: (context) => UserTabPage(),
  UserGroupPage.routeName: (context) => UserGroupPage(),
  GroupConfidants.routeName: (context) => GroupConfidants(),
  AddGeoFenceScreen.routeName: (context) => AddGeoFenceScreen(),
  UserMedicalRecordsScreen.routeName: (context) => UserMedicalRecordsScreen()
};

// TODO: Convert to singleton
// TODO: Build headers
class ServerClient {
  final httpClient = http.Client();
  bool isProd = false;
  final baseURl = "localhost:8080"; //"safezone-backend-nneblk5eda-uc.a.run.app";
  late String apiURL, socketURL;

  final header = {};

  ServerClient() {
    apiURL = isProd ? "https://$baseURl" : "http://$baseURl";
    socketURL = isProd? "wss://$baseURl": "ws://$baseURl";
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
      Uri.parse('$socketURL/group/$groupId'),
    );

    return channel;
  }

  Future<IOWebSocketChannel> connectToLocationsStreaming(String userToken) async {
    final channel = IOWebSocketChannel.connect(
        Uri.parse('$socketURL/stream-group-locations/$userToken'),
        headers: {'Connection': 'upgrade', 'Upgrade': 'websocket'});
    return channel;
  }

  // Gets all the locations from all the user's mutual members
  WebSocketChannel connectToMembersLocationUpdates(String userToken) {
    final channel = WebSocketChannel.connect(
      Uri.parse('$socketURL/get-group-locations/$userToken'),
    );
    return channel;
  }

  Future<dynamic> post(String endPoint, Map<String, dynamic> body,
      {String? token}) async {
    print("$apiURL$endPoint");

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
      
    print("Body is  " +resp.body);
    return jsonDecode(resp.body);
  }

  Future<dynamic> get(String endPoint, {String? token}) async {
    var resp = await httpClient.get(
      Uri.parse("$apiURL$endPoint"),
      headers: buildHeaders(token: token),
    );

    if (resp.statusCode >= 400) {
      // ignore: avoid_print
      throw APIExecption(json.decode(resp.body)['detail']);
    }
    return jsonDecode(resp.body);
  }

  Future<bool> callHook(String hookname, Map<String,dynamic> data, String token) async {
     var resp = await httpClient.post(
      Uri.parse("$apiURL/webhook/$hookname"),
      headers: buildHeaders(token: token),
      body: json.encode(data),
    );

    if (resp.statusCode >= 400) {
      return false;
    } 

    return true;
  }
}

final serverClient = ServerClient();
