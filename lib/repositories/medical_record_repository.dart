import 'package:safezone_frontend/models/medical_record.dart';
import 'package:safezone_frontend/utils.dart';

class MedicalRecordRepository {
  Future<MedicalRecord> createRecord(
      String title, String description, String token) async {
    Map<String, dynamic> body = {"title": title, "description": description};
    Map<String, dynamic> respBody =
        await serverClient.post("/medical-records/", body, token: token);
    return MedicalRecord.fromJson(respBody);
  }

  Future<List<MedicalRecord>> fetchRecords(String token) async {
    List<dynamic> respBody = await serverClient.get("/medical-records/", token: token);
    return respBody.map((e) => MedicalRecord.fromJson(e)).toList();
  }

  Future<List<MedicalRecord>> fetchRecordForUser(int userId, String token) async {
    List<dynamic> respBody = await serverClient.get("/medical-records/$userId", token: token);
    return respBody.map((e) => MedicalRecord.fromJson(e)).toList();
  }
}
