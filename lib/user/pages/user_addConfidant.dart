import 'package:flutter/material.dart';

class AddConfidantPage extends StatelessWidget {
  const AddConfidantPage({super.key});
  static const String route_name = "/add_confidant";
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            const Text(
              'Add Confidant',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3460),
                  decoration: TextDecoration.none),
            ),
            const Text('Scan Barcode to add confidant',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF0F3460),
                    decoration: TextDecoration.none)),
            ElevatedButton(onPressed: () {}, child: const Text('Scan Barcode'))
          ],
        ));
  }
}
