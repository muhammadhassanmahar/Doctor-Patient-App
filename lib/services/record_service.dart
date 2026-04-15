import '../models/record_model.dart';
import 'api_service.dart';

class RecordService {
  // ----------------------------
  // CREATE RECORD
  // ----------------------------
  static Future<RecordModel?> createRecord(RecordModel record) async {
    final res = await ApiService.post("/records", record.toJson());

    if (res is Map<String, dynamic>) {
      return RecordModel.fromJson(res);
    }

    return null;
  }

  // ----------------------------
  // GET RECORDS
  // ----------------------------
  static Future<List<RecordModel>> getRecords() async {
    final res = await ApiService.get("/records");

    if (res is List) {
      return res
          .map((e) => RecordModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }

  // ----------------------------
  // UPDATE RECORD
  // ----------------------------
  static Future<bool> updateRecord(
      String id, Map<String, dynamic> data) async {
    final res = await ApiService.put("/records/$id", data);

    if (res is Map<String, dynamic>) {
      return true;
    }

    return false;
  }

  // ----------------------------
  // DELETE RECORD
  // ----------------------------
  static Future<bool> deleteRecord(String id) async {
    final res = await ApiService.delete("/records/$id");

    if (res is Map<String, dynamic>) {
      return true;
    }

    return false;
  }
}