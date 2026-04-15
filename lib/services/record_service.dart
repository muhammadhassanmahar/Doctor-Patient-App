import '../models/record_model.dart';
import 'api_service.dart';

class RecordService {
  // ----------------------------
  // CREATE RECORD (DOCTOR ONLY)
  // ----------------------------
  static Future<RecordModel?> createRecord(RecordModel record) async {
    final res = await ApiService.post("/records", record.toJson());

    if (res is Map) {
      return RecordModel.fromJson(res);
    }

    return null;
  }

  // ----------------------------
  // GET RECORDS (DOCTOR / PATIENT)
  // ----------------------------
  static Future<List<RecordModel>> getRecords() async {
    final res = await ApiService.get("/records");

    if (res is List) {
      return res.map((e) => RecordModel.fromJson(e)).toList();
    }

    return [];
  }

  // ----------------------------
  // UPDATE RECORD
  // ----------------------------
  static Future<bool> updateRecord(
      String id, Map<String, dynamic> data) async {
    final res = await ApiService.put("/records/$id", data);

    if (res is Map) {
      return true;
    }

    return false;
  }

  // ----------------------------
  // DELETE RECORD
  // ----------------------------
  static Future<bool> deleteRecord(String id) async {
    final res = await ApiService.delete("/records/$id");

    if (res is Map) {
      return true;
    }

    return false;
  }
}