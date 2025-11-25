import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ems/Dashboard/Bottom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PunchScannerScreen extends ConsumerStatefulWidget {
  const PunchScannerScreen({super.key});

  @override
  ConsumerState<PunchScannerScreen> createState() => _PunchScannerScreenState();
}

class _PunchScannerScreenState extends ConsumerState<PunchScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;

  String? scannedCode;
  Map<String, dynamic>? qrJson;

  @override
  void initState() {
    super.initState();
    _askCameraPermission();
  }

  Future<void> _askCameraPermission() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) openAppSettings();
  }

  /// --------- QR DECODE ----------
  Map<String, dynamic>? decodeQR(String raw) {
    try {
      final decodedBytes = base64Decode(raw);
      return json.decode(utf8.decode(decodedBytes));
    } catch (_) {}

    try {
      return json.decode(raw);
    } catch (_) {}

    return null;
  }

  /// --------- QR MATCH CHECK ----------
  bool validateQR(Map qrJson, String userEmail) {
    return qrJson["employee_email"].toString().toLowerCase() ==
        userEmail.toLowerCase();
  }

  /// --------- CALL PUNCH API ----------
  Future<Map<String, dynamic>?> punchApiCall(String qrAction) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? email = prefs.getString("login_email");
      String? password = prefs.getString("login_password");
      String? token = prefs.getString("token");

      print("📌 EMAIL = $email");
      print("📌 PASSWORD = $password");
      print("📌 TOKEN = $token");

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";
      dio.options.headers["Accept"] = "application/json";

      print("➡ SENDING ACTION TO API: $qrAction");

      final response = await dio.post(
        "http://tmshrmanagement.techmetworks.com/api/employee/attendance/punchinpunchout",
        data: {"email": email, "password": password, "action": qrAction},
      );

      print("✅ API RESPONSE:");
      print(response.data);

      return response.data;
    } catch (e) {
      print("❌ Punch API Error: $e");
      if (e is DioException) {
        print(
          "❌ DioException: ${e.response?.data}, Status=${e.response?.statusCode}",
        );
      }
      return null;
    }
  }

  /// --------- SUCCESS SCREEN ----------
  void showSuccessPage(String action) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen(action: action)),
    );
  }

  /// --------- ERROR POPUP ----------
  void showError(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// -------- MAIN UI ----------
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Image.asset("assets/images/tms_logo.png", height: 40),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const Text(
              "Punch In / Out",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // CAMERA
            Container(
              width: w * 0.75,
              height: w * 1.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MobileScanner(
                  controller: cameraController,
                  onDetect: (capture) async {
                    final rawQR = capture.barcodes.first.rawValue;
                    if (rawQR == null || isProcessing) return;

                    setState(() => isProcessing = true);

                    print("=============== RAW QR SCANNED ===============");
                    print(rawQR);

                    /// 1️⃣ Decode QR
                    final decoded = decodeQR(rawQR);
                    if (decoded == null) {
                      showError("Invalid QR Code Format");
                      setState(() => isProcessing = false);
                      return;
                    }

                    scannedCode = jsonEncode(decoded);
                    qrJson = decoded;

                    print("=============== DECODED QR JSON ===============");
                    print(decoded);

                    /// 2️⃣ Validate QR belongs to logged-in employee
                    final prefs = await SharedPreferences.getInstance();
                    String email = prefs.getString("login_email") ?? "";

                    if (!validateQR(decoded, email)) {
                      showError("This QR does not belong to your account!");
                      setState(() => isProcessing = false);
                      return;
                    }

                    /// 3️⃣ Hit Punch API
                    final api = await punchApiCall(decoded["action"]);

                    print("=============== API RESULT ===============");

                    if (api == null) {
                      showError("Server Error");
                    } else if (api["success"] == true) {
                      showSuccessPage(decoded["action"]);
                    } else {
                      showError(api["message"] ?? "Invalid QR Data");
                    }

                    await Future.delayed(const Duration(seconds: 1));
                    setState(() => isProcessing = false);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            scannedCode == null
                ? const Text(
                    "No QR scanned",
                    style: TextStyle(color: Colors.grey),
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      scannedCode!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatefulWidget {
  final String action;
  const SuccessScreen({super.key, required this.action});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    /// Redirect after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainHomeScreen(initialTab: BottomTab.home),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          widget.action == "punch_in"
              ? "Successfully Punch In"
              : "Successfully Punch Out",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
