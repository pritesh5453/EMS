import 'package:dio/dio.dart';
import 'package:ems/Model/attendance_model.dart';
import 'package:ems/util/network_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'QR_Scanner.dart';

class AttendanceHomeScreen extends StatefulWidget {
  const AttendanceHomeScreen({super.key});

  @override
  State<AttendanceHomeScreen> createState() => _AttendanceHomeScreenState();
}

class _AttendanceHomeScreenState extends State<AttendanceHomeScreen> {
  attendance_history? attendanceData;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    print("========================================");
    print("📌 AttendanceHomeScreen INIT CALLED");
    print("========================================");

    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    print("========================================");
    print("🔵 FetchAttendance() CALLED");
    setState(() => loading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    print("➡ Saved Token (may or may not be used): $token");

    try {
      Dio dio = Dio();

      // Headers
      dio.options.headers["Accept"] = "application/json";
      // Token header optional hai, rakhenge (future ke liye)
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }

      // 🔥 IMPORTANT: Backend ko email + password chahiye
      final _ = await SharedPreferences.getInstance();
      final email = prefs.getString("login_email");
      final password = prefs.getString("login_password");

      print("➡ Sending POST request to Attendance API...");
      print("➡ Email: $email");
      print("➡ Password: $password");

      final response = await dio.post(
        "https://tmshrmanagement.techmetworks.com/api/employee/attendance/history",
        data: {"email": email, "password": password},
      );

      print("========================================");
      print("✅ RAW API RESPONSE:");
      print(response.data);

      attendanceData = attendance_history.fromJson(response.data);

      print("----------------------------------------");
      print("📌 Parsed Model Data:");
      print("Success: ${attendanceData?.success}");
      print("Message: ${attendanceData?.message}");
      print("Total Records: ${attendanceData?.data?.length}");
      print("----------------------------------------");
    } catch (e) {
      print("========================================");
      print("❌ ERROR Fetching Attendance:");

      if (e is DioException) {
        print("❌ API ERROR BODY: ${e.response?.data}");
        print("❌ STATUS CODE: ${e.response?.statusCode}");
      }

      print(e);
      print("========================================");
    }

    setState(() => loading = false);
    print("🔵 fetchAttendance() COMPLETED");
    print("========================================");
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    print("📌 AttendanceHomeScreen BUILD TRIGGERED");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: h * 0.02),

                    Image.asset("assets/images/tms_logo.png", height: h * 0.08),

                    SizedBox(height: h * 0.03),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                      child: SizedBox(
                        width: double.infinity,
                        height: h * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F9BD7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            print(
                              "➡ CHECKING WiFi before navigating to PunchScannerScreen...",
                            );

                            // Allowed gateways list
                            bool allowed =
                                await NetworkService.isAllowedNetwork([
                                  "192.168.1.1",
                                  "192.168.0.1",
                                ]);

                            if (!allowed) {
                              print("❌ WiFi NOT allowed");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please connect to Company WiFi to Check In/Out",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return; // Stop navigation
                            }

                            print(
                              "✅ WiFi ALLOWED → Navigating to PunchScannerScreen",
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PunchScannerScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            "Check In/Out",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    attendanceData?.data == null
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "No attendance history found",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: attendanceData!.data!.length,
                            itemBuilder: (context, index) {
                              final item = attendanceData!.data![index];

                              print(
                                "🟢 Building Attendance Card for: ${item.date} | Status: ${item.status}",
                              );

                              Color statusColor;
                              if (item.status?.toLowerCase() == "present") {
                                statusColor = Colors.green.shade300;
                              } else if (item.status?.toLowerCase() == "late") {
                                statusColor = Colors.orange.shade300;
                              } else {
                                statusColor = Colors.red.shade300;
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.05,
                                  vertical: h * 0.01,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(w * 0.04),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F4F9),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.date ?? "",
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              item.status ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: h * 0.005),

                                      Text(
                                        item.attendanceType ?? "",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),

                                      SizedBox(height: h * 0.02),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _punch(
                                            "Punch In",
                                            item.punchInTime?.toString(),
                                          ),
                                          _punch(
                                            "Punch Out",
                                            item.punchOutTime?.toString(),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: h * 0.02),
                                      Container(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(height: h * 0.015),

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 20,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Worked Hours: ${item.workedHours ?? "0"}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                    SizedBox(height: h * 0.05),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _punch(String title, String? value) {
    print("📌 Punch Column → $title : ${value ?? "-"}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Text(
          value ?? "-",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
