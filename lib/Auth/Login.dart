import 'package:ems/Dashboard/Bottom_tab.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

                  /// ---------- LOGO ----------
                  Image.asset(
                    "assets/images/tms_logo.png", // replace with your logo
                    height: h * 0.08,
                  ),

                  SizedBox(height: h * 0.08),

                  /// ---------- WELCOME TEXT ----------
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

                  /// ---------- USERNAME ----------
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

                  /// ---------- PASSWORD ----------
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

                  /// ---------- LOGIN BUTTON ----------
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F7DAE), // Blue shade
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainHomeScreen(
                              initialTab: BottomTab.home,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
