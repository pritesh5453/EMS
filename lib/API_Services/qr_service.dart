import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ems/Model/qr_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRService {
  Future<Map<String, dynamic>?> punchApiCall(
    Map<String, dynamic> qrJson,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? email = prefs.getString("login_email");
      String? password = prefs.getString("login_password");
      String? token = prefs.getString("token");

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";
      dio.options.headers["Accept"] = "application/json";

      final data = {
        "email": email,
        "password": password,
        "action": qrJson["action"], // 🎯 REQUIRED
        "qr_data": json.encode(qrJson), // 🎯 FULL QR JSON
      };

      print("📤 FINAL API DATA:");
      print(data);

      final response = await dio.post(
        "http://tmshrmanagement.techmetworks.com/api/employee/attendance/punchinpunchout",
        data: data,
      );

      print("📥 API RESPONSE:");
      print(response.data);

      return response.data;
    } catch (e) {
      print("❌ Punch API Error: $e");

      if (e is DioException) {
        print("❌ RESPONSE: ${e.response?.data}");
        print("❌ STATUS: ${e.response?.statusCode}");
      }
      return null;
    }
  }
}
