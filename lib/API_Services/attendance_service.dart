import 'package:dio/dio.dart';
import 'package:ems/Model/attendance_model.dart';

class AttendanceService {
  Future<attendance_history?> fetchAttendance({
    required String email,
    required String password,
  }) async {
    try {
      Dio dio = Dio();
      dio.options.headers["Accept"] = "application/json";

      final response = await dio.post(
        "https://tmshrmanagement.techmetworks.com/api/employee/attendance/history",
        data: {"email": email, "password": password},
      );

      print("✅ ATTENDANCE RAW RESPONSE:");
      print(response.data);

      return attendance_history.fromJson(response.data);
    } catch (e) {
      print("❌ ERROR fetching attendance: $e");
      return null;
    }
  }
}
