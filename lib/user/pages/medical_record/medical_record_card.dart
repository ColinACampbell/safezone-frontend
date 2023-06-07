import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/medical_record.dart';
import 'package:safezone_frontend/utils.dart';

class MedicalRecordCard extends StatelessWidget {
  final MedicalRecord _record;
  final bool isLastCard;
  const MedicalRecordCard(this._record, this.isLastCard, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        //Navigator.pushNamed(context, AddGeoFenceScreen.routeName, arguments: {"user":_confidant.details, "group":_group});
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: !isLastCard
            ? const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: .5)))
            : null,
        child: Row(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _record.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    _record.description,
                    style: TextStyle(fontSize: 13),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          color: accentColor,
                          onPressed: () {},
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          color: accentColor,
                          onPressed: () {},
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
