class UserModel {
  final String? id;
  final String username;
  final String role;

  UserModel({
    this.id,
    required this.username,
    required this.role,
  });

  // ----------------------------
  // FROM JSON (BACKEND → FLUTTER)
  // ----------------------------
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"]?.toString(),
      username: json["username"] ?? "",
      role: json["role"] ?? "",
    );
  }

  // ----------------------------
  // TO JSON (FLUTTER → BACKEND)
  // ----------------------------
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "role": role,
    };
  }
}