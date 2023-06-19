import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_frontend/models/group.dart';
import 'package:safezone_frontend/models/medical_record.dart';
import 'package:safezone_frontend/providers/providers.dart';
import 'package:safezone_frontend/user/pages/group/confidant_card.dart';
import 'package:safezone_frontend/user/pages/medical_record/medical_record_card.dart';
import 'package:safezone_frontend/widgets/app_bar.dart';
import 'package:safezone_frontend/widgets/app_text_field.dart';

class ConfidantScreen extends ConsumerStatefulWidget {
  static const String routeName = "/group_confidant";

  const ConfidantScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ConfidantScreenState();
  }
}

class _ConfidantScreenState extends ConsumerState<ConfidantScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      // final int groupId = ModalRoute.of(context)!.settings.arguments as int;
      // await ref.read(groupsProvider).fetchGroup(groupId);
    });
  }

  Widget renderNothingToShow() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Center(child: Text("There's nothing here to show")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Confidant confidant =
        ModalRoute.of(context)!.settings.arguments as Confidant;

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Confidant Details"),
          const Text(
            "Medical Records",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: ref
                  .read(medicalRecordProvider)
                  .fetchRecordForUser(confidant.details.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MedicalRecord> records =
                      snapshot.data as List<MedicalRecord>;
                  if (records.isEmpty)
                    // ignore: curly_braces_in_flow_control_structures
                    return renderNothingToShow();
                  else
                    // ignore: curly_braces_in_flow_control_structures
                    return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: records.length,
                        itemBuilder: (context, idx) {
                          return MedicalRecordCard(
                              records[idx], records.last == records[idx],
                              showControls: false);
                        });
                }
                return const CircularProgressIndicator();
              }),
          const Text(
            "Geofences",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: ref
                  .read(medicalRecordProvider)
                  .fetchRecordForUser(confidant.details.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MedicalRecord> records =
                      snapshot.data as List<MedicalRecord>;

                  return renderNothingToShow();
                }
                return Text("Hello");
              })
        ],
      ),
    );
  }
}
