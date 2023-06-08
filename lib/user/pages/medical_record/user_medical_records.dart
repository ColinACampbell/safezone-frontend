import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/exception.dart';
import 'package:safezone_frontend/models/medical_record.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/medical_record/medical_record_card.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/app_text_field.dart';

class UserMedicalRecordsScreen extends ConsumerStatefulWidget {
  static const String routeName = "/user_medical_records_screen";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserMedicalRecordsScreenState();
  }
}

class _UserMedicalRecordsScreenState extends ConsumerState {
  // List<MedicalRecord> medRecords = [
  //   MedicalRecord(1, 1, "Test",
  //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"),
  //   MedicalRecord(2, 1, "Test 2",
  //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat")
  // ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      try {
        ref.read(medicalRecordProvider).fetchRecords();
      } on APIExecption catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      } on Exception catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var medRecords = ref.watch(medicalRecordProvider).records;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Implement
          },
          child: Icon(Icons.add)),
      body: Column(
        children: [
          CustomAppBar(title: "My Medical Records"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppTextField(hintText: "Search", onSaved: (val) {}),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: medRecords.length,
                  itemBuilder: (context, idx) {
                    return MedicalRecordCard(
                        medRecords[idx], medRecords.last == medRecords[idx]);
                  }))
        ],
      ),
    );
  }
}
