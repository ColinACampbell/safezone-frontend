import 'dart:js';
import 'package:safezone_frontend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:safezone_frontend/user/pages/user_sos.dart';
import 'package:safezone_frontend/widgets/map.dart';
import 'package:barcode_widget/barcode_widget.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);
  @override
  State<UserHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<UserHomePage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Expanded(
                child: AppMap(locationsStream: null, initLat: 0, initLong: 0)),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserSOSPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        minimumSize: Size(100, 48),
                      ),
                      child: Text('SOS'),
                    ))),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 400,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Close')),
                                      ),
                                    ),
                                    BarcodeWidget(
                                        data: 'idnumber',
                                        barcode: Barcode.code128(),
                                        width: 200,
                                        height: 200)
                                  ],
                                ),
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 3, 144, 8),
                        minimumSize: Size(100, 48),
                      ),
                      child: Text('BarCode'),
                    )))
          ],
        ),
      ),
    );
  }

  showCoordinates(lat, long) {
    return Text("Lat is $lat, Long is $long");
  }
}
