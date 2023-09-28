import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:karel/Model/register_model.dart';
import 'package:karel/Model/login_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static Future<LoginModel?> loginCall(
      {required String username, required String password}) async {
    final body = {"username": username, "password": password};
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
    };

    //172.20.10.4:8000 karel
    //192.168.0.14:8000 ev
    var response = await http.post(
        Uri.parse("http://172.20.10.4:8000/auth/login"),
        body: jsonEncode(body),
        headers: header);
    try {
      if (response.statusCode == 200) {
        var result = LoginModel.fromJson(jsonDecode(response.body));

        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", result.token.toString());

        print(prefs.getString("token"));

        return result;
      } else {
        throw ("Error");
      }
    } catch (e) {}
  }

  static Future<RegisterModel?> registerCall(
      {required String username, required String password}) async {
    final body = {"username": username, "password": password};
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
    };
    var response = await http.post(
        Uri.parse("http://172.20.10.4:8000/create_user/"),
        headers: header,
        body: jsonEncode(body));
    try {
      if (response.statusCode == 200) {
        var result = RegisterModel.fromJson(jsonDecode(response.body));

        return result;
      } else {
        throw ("Error");
      }
    } catch (e) {}
  }

  static Future<void> addLocation(String qrValue) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw ("Token not found");
    }

    final body = jsonEncode({
      "location": qrValue,
      "enterTime": DateTime.now().toIso8601String(),
      "outTime": "" // Set an empty outTime initially
    });

    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      'Authorization': token
    };

    var response = await http.post(
        Uri.parse("http://172.20.10.4:8000/user/addQr"),
        headers: header,
        body: body);

    if (response.statusCode != 200) {
      throw ("Failed to add location");
    }
  }

  static Future<void> updateOutTime(String qrValue) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) {
      throw ("Token not found");
    }

    final body = jsonEncode({"location": qrValue});

    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      'Authorization': token
    };
    var response = await http.put(
        Uri.parse("http://172.20.10.4:8000/user/update_end_time"),
        headers: header,
        body: body);

    if (response.statusCode != 200) {
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw ("Failed to update out time");
    }
  }
}
