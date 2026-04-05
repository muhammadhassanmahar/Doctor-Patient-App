class UserModel {
  final String username;
  final String role;
  final String? token;

  UserModel({required this.username, required this.role, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json["sub"] ?? "",
      role: json["role"] ?? "patient",
      token: json["access_token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sub": username,
      "role": role,
      "access_token": token,
    };
  }
}