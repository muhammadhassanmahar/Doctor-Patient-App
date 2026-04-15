import '../models/record_model.dart';
import 'api_service.dart';

class RecordService {
  // ----------------------------
  // CREATE RECORD (DOCTOR)
  // ----------------------------
  static Future<RecordModel?> createRecord(RecordModel record) async {
    final res = await ApiService.post("/records", record.toJson());

    if (res["id"] != null) {
      return RecordModel.fromJson(res);
    }
    return null;
  }

  // ----------------------------
  // GET RECORDS (DOCTOR/PATIENT)
  // ----------------------------
  static Future<List<RecordModel>> getRecords() async {
    final res = await ApiService.get("/records");

    List data = res;

    return data.map((e) => RecordModel.fromJson(e)).toList();
  }

  // ----------------------------
  // UPDATE RECORD
  // ----------------------------
  static Future<bool> updateRecord(
      String id, Map<String, dynamic> data) async {
    final res = await ApiService.put("/records/$id", data);

    return res["id"] != null;
  }
}