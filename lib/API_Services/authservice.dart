import 'package:dio/dio.dart';
import 'package:ems/Model/login_model.dart';

class AuthService {
  Future<Login?> login(String email, String password) async {
    try {
      var response = await Dio().post(
        "http://tmshrmanagement.techmetworks.com/api/employee/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        return Login.fromJson(response.data);
      }
    } catch (e) {
      print("Login error: $e");
    }
    return null;
  }
}
