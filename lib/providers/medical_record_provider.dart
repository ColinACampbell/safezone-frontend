import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safezone_frontend/models/medical_record.dart';
import 'package:safezone_frontend/providers/user_provider.dart';
import 'package:safezone_frontend/repositories/medical_record_repository.dart';

class MedicalRecordProvider extends ChangeNotifier {
  final MedicalRecordRepository _medicalRecordRepository;
  final UserProvider _userProvider;

  List<MedicalRecord> records = [];

  MedicalRecordProvider(this._medicalRecordRepository, this._userProvider);

  createGroup(String title, String description) async {
    final newRecord = await _medicalRecordRepository.createRecord(
        title, description, _userProvider.currentUser!.token!);
    records.add(newRecord);
    notifyListeners();
  }

  Future<List<MedicalRecord>> fetchRecords() async {
    var newRecords = await _medicalRecordRepository
        .fetchRecords(_userProvider.currentUser!.token!);
    records = [];
    records.addAll(newRecords);
    notifyListeners();
    return records;
  }
}
