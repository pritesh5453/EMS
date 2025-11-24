import 'package:dio/dio.dart';
import 'package:ems/Dashboard/Bottom_tab.dart';
import 'package:ems/Model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<Login?> loginApi() async {
    String url = "http://tmshrmanagement.techmetworks.com/api/employee/login";

    print("========================================");
    print("🔵 LOGIN API CALLED");
    print("➡ URL: $url");
    print("➡ EMAIL: ${usernameController.text.trim()}");
    print("➡ PASSWORD: ${passwordController.text.trim()}");
    print("========================================");

    try {
      var response = await Dio().post(
        url,
        data: {
          "email": usernameController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      print("✅ RAW RESPONSE:");
      print(response.data);

      Login loginModel = Login.fromJson(response.data);

      print("========================================");
      print("📌 Parsed Model Data:");
      print("Success: ${loginModel.success}");
      print("Message: ${loginModel.message}");
      print("Token: ${loginModel.data?.token}");
      print("Employee Name: ${loginModel.data?.employee?.name}");
      print("========================================");

      return loginModel;
    } catch (e) {
      print("========================================");
      print("❌ LOGIN ERROR");
      print(e);
      print("========================================");
      return null;
    }
  }

  // --------------------------------------------------------------------------
  // 🔥 FINAL UPDATED LOGIN HANDLER — SAVES TOKEN + EMAIL + PASSWORD
  // --------------------------------------------------------------------------
  void handleLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter all fields")));
      return;
    }

    print("🔵 VALIDATION PASSED — Calling loginApi()...");

    setState(() => isLoading = true);

    final result = await loginApi();

    setState(() => isLoading = false);

    if (result != null && result.success == true) {
      print("========================================");
      print("🎉 LOGIN SUCCESS!");
      print("Message: ${result.message}");
      print("Token: ${result.data?.token}");
      print("========================================");

      final prefs = await SharedPreferences.getInstance();

      // 🔥 SAVE TOKEN
      await prefs.setString("token", result.data!.token!);

      // 🔥🔥 SAVE USER EMAIL + PASSWORD FOR PROFILE & ATTENDANCE API
      await prefs.setString("login_email", usernameController.text.trim());
      await prefs.setString("login_password", passwordController.text.trim());

      print("💾 Token, Email & Password saved successfully!");
      print("➡ Saved Email: ${usernameController.text.trim()}");
      print("➡ Saved Password: ${passwordController.text.trim()}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MainHomeScreen(initialTab: BottomTab.home),
        ),
      );
    } else {
      print("========================================");
      print("⚠ LOGIN FAILED");
      print("Message: ${result?.message}");
      print("========================================");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result?.message ?? "Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: h,
            width: w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h * 0.06),

                  Image.asset("assets/images/tms_logo.png", height: h * 0.08),

                  SizedBox(height: h * 0.08),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: h * 0.01),

                  const Text(
                    "Login to manage attendance securely.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  SizedBox(height: h * 0.05),

                  // ---------------- USERNAME ----------------
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.008),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EFF4),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Enter admin username",
                        hintStyle: const TextStyle(color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: w * 0.05,
                          vertical: h * 0.018,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  // ---------------- PASSWORD ----------------
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.008),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EFF4),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        hintStyle: const TextStyle(color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: w * 0.05,
                          vertical: h * 0.018,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.05),

                  // ---------------- LOGIN BUTTON ----------------
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F7DAE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: isLoading ? null : handleLogin,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
