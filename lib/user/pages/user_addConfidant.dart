import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddConfidantPage extends StatelessWidget {
  const AddConfidantPage({super.key});
  static const String route_name = "/add_confidant";
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                'Add Confidant',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F3460),
                    decoration: TextDecoration.none),
              ),
            ),
            const Text('Scan Barcode to add confidant',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF0F3460),
                    decoration: TextDecoration.none)),
            Padding(
                padding: EdgeInsets.only(top: 30),
                child:
                    Image(image: AssetImage('assets/phone_with_barcode.png'))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            onPressed: () async {
                              await FlutterBarcodeScanner.scanBarcode(
                                '#ff6666',
                                'Cancel',
                                true,
                                ScanMode.BARCODE,
                              );
                            },
                            child: const Text('Scan Barcode'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(250, 50),
                                backgroundColor: Color(0xFF0F3460))))))
          ],
        ));
  }
}
