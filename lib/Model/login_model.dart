// To parse this JSON data, do
//
//     final api = apiFromJson(jsonString);

import 'dart:convert';

LoginModel apiFromJson(String str) => LoginModel.fromJson(json.decode(str));

String apiToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String status;
  String token;

  LoginModel({
    required this.status,
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "token": token,
      };
}
