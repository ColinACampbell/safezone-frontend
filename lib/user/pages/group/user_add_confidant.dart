import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:safezone_frontend/widgets/app_button.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AddConfidantPage extends StatefulWidget {
  final String groupId;
  const AddConfidantPage({super.key, required this.groupId});
  static const String route_name = "/add_confidant";

  @override
  State<AddConfidantPage> createState() => _AddConfidantPageState();
}

class _AddConfidantPageState extends State<AddConfidantPage> {
  int? user_id;
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
                style: const TextStyle(
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
            const Padding(
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future barcodeScanner() async {
    try {
      setState(() async {
        var res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SimpleBarcodeScannerPage(),
            ));
        setState(() {
          if (isNumeric(res)) {
            user_id = res;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid safezone barcode")));
          }
        });
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Looks like something went wrong")));
    }
  }
}
