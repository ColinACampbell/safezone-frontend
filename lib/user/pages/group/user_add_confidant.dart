import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:safezone_frontend/widgets/app_button.dart';

class AddConfidantPage extends StatefulWidget {
  final String groupId;
  const AddConfidantPage({super.key, required this.groupId});
  static const String route_name = "/add_confidant";

  @override
  State<AddConfidantPage> createState() => _AddConfidantPageState();
}

class _AddConfidantPageState extends State<AddConfidantPage> {
  String scanResult = "None";
  int val = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                'Add Confidant $scanResult',
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
                        child: AppButton(
                          onTap: () {
                            barcodeScanner();
                          },
                          text: 'Scan Barcode',
                        ))))
          ],
        ));
  }

  Future barcodeScanner() async {
    try {
      setState(() async {
        scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.BARCODE,
        );
      });
    } on PlatformException catch(e)  {
      print("An error occured scanning");
      print(e.message);
      print(e);
      setState(() {
        scanResult = 'Nan';
      });
    }
  }
}
