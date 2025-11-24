import 'package:dio/dio.dart';
import 'package:ems/Model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  Future<Profile?> fetchProfile() async {
    print("========================================");
    print("🔵 FetchProfile() CALLED");

    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("token");
      final email = prefs.getString("login_email");
      final password = prefs.getString("login_password");

      print("➡ Token: $token");
      print("➡ Logged-in Email: $email");
      print("➡ Logged-in Password: $password");

      if (email == null || password == null) {
        print("❌ ERROR: Email or Password not found in SharedPreferences!");
        return null;
      }

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";
      dio.options.headers["Accept"] = "application/json";

      print("➡ Sending POST request to Profile API...");

      final response = await dio.post(
        "https://tmshrmanagement.techmetworks.com/api/employee/profile",
        data: {"email": email, "password": password},
      );

      print("========================================");
      print("✅ RAW PROFILE RESPONSE:");
      print(response.data);

      return Profile.fromJson(response.data);
    } catch (e) {
      print("========================================");
      print("❌ ERROR Fetching Profile:");

      if (e is DioException) {
        print("❌ API ERROR: ${e.response?.data}");
        print("❌ STATUS CODE: ${e.response?.statusCode}");
      }

      return null;
    }
  }
}
