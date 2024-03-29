import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/exception.dart';
import 'package:safezone_frontend/models/medical_record.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/medical_record/medical_record_card.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/app_button.dart';
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
            showModalBottomSheet(
                isScrollControlled: true, // take up the full height required
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (context) {
                  return buildCreateMedicalRecordBottomSheet();
                });
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
                        medRecords[idx], true);
                  }))
        ],
      ),
    );
  }

  buildCreateMedicalRecordBottomSheet() {
    String recordTitle = "";
    String recordDescription = "";
    final _form = GlobalKey<FormState>();

    return Container(
      //padding: const EdgeInsets.all(15),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          left: 10,
          top: 10,
          right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _form,
            child: Column(
              children: [
                AppTextField(
                    hintText: "Enter Record Title",
                    autoFocus: true,
                    onSaved: (val) {
                      recordTitle = val!;
                    }),
                SizedBox(height: 10),
                AppTextField(
                    hintText: "Enter Record Description",
                    autoFocus: true,
                    onSaved: (val) {
                      recordDescription = val!;
                    })
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                    child: AppButton(
                  text: "Add Medical Record",
                  onTap: () async {
                    _form.currentState!.save();
                    try {
                      await ref
                          .read(medicalRecordProvider)
                          .createRecord(recordTitle, recordDescription);
                      Navigator.pop(context);
                    } on APIExecption catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.message)));
                    } on Exception catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  width: 100,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
