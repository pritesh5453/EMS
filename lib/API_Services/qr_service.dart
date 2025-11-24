import 'package:dio/dio.dart';
import 'package:ems/Model/qr_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRService {
  Future<QR?> punchInPunchOut(String qrData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? email = prefs.getString("login_email");
      String? password = prefs.getString("login_password");
      String? token = prefs.getString("token");

      if (email == null || password == null) {
        print("❌ ERROR: Login email/password missing");
        return null;
      }

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";
      dio.options.headers["Accept"] = "application/json";

      print("🔵 Sending PunchInPunchOut API request...");
      print("➡ Email: $email");
      print("➡ QR Data: $qrData");

      final response = await dio.post(
        "http://tmshrmanagement.techmetworks.com/api/employee/attendance/punchinpunchout",
        data: {"email": email, "password": password, "qr_data": qrData},
      );

      print("✅ RAW Punch API RESPONSE:");
      print(response.data);

      return QR.fromJson(response.data);
    } catch (e) {
      print("❌ Punch API ERROR: $e");
      if (e is DioException) print("BODY: ${e.response?.data}");
      return null;
    }
  }
}
