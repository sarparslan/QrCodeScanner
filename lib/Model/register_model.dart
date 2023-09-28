// To parse this JSON data, do
//
//     final api = apiFromJson(jsonString);

import 'dart:convert';

RegisterModel apiFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String apiToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  String status;
  String message;
  String userId;
  String username;

  RegisterModel({
    required this.status,
    required this.message,
    required this.userId,
    required this.username,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        status: json["status"],
        message: json["message"],
        userId: json["user_id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user_id": userId,
        "username": username,
      };
}
