class RecordModel {
  final String? id;
  final String patient;
  final String? doctor;
  final String diagnosis;
  final String prescription;
  final DateTime? createdAt;

  RecordModel({
    this.id,
    required this.patient,
    this.doctor,
    required this.diagnosis,
    required this.prescription,
    this.createdAt,
  });

  // ----------------------------
  // FROM JSON (BACKEND → FLUTTER)
  // ----------------------------
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json["_id"]?.toString() ?? json["id"]?.toString(),
      patient: json["patient"] ?? "",
      doctor: json["doctor"],
      diagnosis: json["diagnosis"] ?? "",
      prescription: json["prescription"] ?? "",
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"].toString())
          : null,
    );
  }

  // ----------------------------
  // TO JSON (FLUTTER → BACKEND)
  // ----------------------------
  Map<String, dynamic> toJson() {
    return {
      "patient": patient,
      "diagnosis": diagnosis,
      "prescription": prescription,
    };
  }
}