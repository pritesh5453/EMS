import 'package:dio/dio.dart';
import 'package:ems/Dashboard/Bottom_tab.dart';
import 'package:ems/Model/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceLogsScreen extends StatefulWidget {
  const AttendanceLogsScreen({super.key});

  @override
  State<AttendanceLogsScreen> createState() => _AttendanceLogsScreenState();
}

class _AttendanceLogsScreenState extends State<AttendanceLogsScreen> {
  attendance_history? attendanceData;
  attendance_history? filteredData;

  bool loading = false;

  // Status filter
  String selectedFilter = "All"; // All / Present / Late / Absent

  // Filter chips visibility
  bool showStatusChips = true;

  // Date range filter
  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    setState(() => loading = true);

    print("========================================");
    print("🔵 AttendanceLogsScreen → fetchAttendance() CALLED");
    print("========================================");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      print("➡ Saved Token: $token");

      Dio dio = Dio();
      dio.options.headers["Accept"] = "application/json";
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }

      // Hardcoded because backend needs it
      final _ = await SharedPreferences.getInstance();
      final email = prefs.getString("login_email");
      final password = prefs.getString("login_password");

      print("➡ Sending POST request to Attendance History API...");
      print("➡ Email: $email");
      print("➡ Password: $password");

      final response = await dio.post(
        "https://tmshrmanagement.techmetworks.com/api/employee/attendance/history",
        data: {"email": email, "password": password},
      );

      print("✅ RAW ATTENDANCE RESPONSE:");
      print(response.data);

      attendanceData = attendance_history.fromJson(response.data);
      print("➡ Parsed Records: ${attendanceData?.data?.length}");

      // Initially: all data visible
      _applyAllFilters();
    } catch (e) {
      print("❌ ERROR in fetchAttendance: $e");
    }

    setState(() => loading = false);
  }

  // Apply BOTH filters: status + date range
  void _applyAllFilters() {
    print("🔁 _applyAllFilters() CALLED");
    print("➡ Current Status Filter: $selectedFilter");
    print(
      "➡ Current DateRange: ${selectedRange?.start} - ${selectedRange?.end}",
    );

    if (attendanceData?.data == null) {
      filteredData = attendanceData;
      return;
    }

    List<Data> list = List<Data>.from(attendanceData!.data!);

    // 1) Status filter
    if (selectedFilter != "All") {
      list = list
          .where(
            (e) =>
                (e.status ?? "").toLowerCase() == selectedFilter.toLowerCase(),
          )
          .toList();
    }

    // 2) Date range filter
    if (selectedRange != null) {
      final start = DateTime(
        selectedRange!.start.year,
        selectedRange!.start.month,
        selectedRange!.start.day,
      );
      final end = DateTime(
        selectedRange!.end.year,
        selectedRange!.end.month,
        selectedRange!.end.day,
      );

      list = list.where((e) {
        if (e.date == null) return false;
        try {
          final d = DateTime.parse(e.date!); // "2025-11-24"
          final onlyDate = DateTime(d.year, d.month, d.day);

          final isInRange =
              (onlyDate.isAfter(start) && onlyDate.isBefore(end)) ||
              onlyDate.isAtSameMomentAs(start) ||
              onlyDate.isAtSameMomentAs(end);

          return isInRange;
        } catch (_) {
          return false;
        }
      }).toList();
    }

    filteredData = attendance_history(
      success: attendanceData!.success,
      message: attendanceData!.message,
      data: list,
    );

    print("➡ Filtered Records: ${filteredData?.data?.length}");
  }

  void applyFilter(String status) {
    print("🎯 applyFilter CALLED with: $status");
    setState(() {
      selectedFilter = status;
      _applyAllFilters();
    });
  }

  Future<void> _pickDateRange() async {
    print("📅 _pickDateRange() CALLED");

    final now = DateTime.now();

    final initialRange =
        selectedRange ??
        DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        // Chota sa normal date range dialog
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF003A64),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      print("✅ DateRange SELECTED: ${picked.start} → ${picked.end}");
      setState(() {
        selectedRange = picked;
        _applyAllFilters();
      });
    } else {
      print("⚠ DateRange selection CANCELLED");
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final d = date.day.toString().padLeft(2, '0');
    final m = months[date.month - 1];
    final y = date.year.toString();

    // Tu ne "B" bola tha, isliye long format rakha:
    // 12 Nov 2025 - 24 Nov 2025
    return "$d $m $y";
  }

  String _getDateRangeLabel() {
    if (selectedRange == null) return "Date Range";

    final start = DateTime(
      selectedRange!.start.year,
      selectedRange!.start.month,
      selectedRange!.start.day,
    );
    final end = DateTime(
      selectedRange!.end.year,
      selectedRange!.end.month,
      selectedRange!.end.day,
    );

    return "${_formatDate(start)} - ${_formatDate(end)}";
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainHomeScreen(initialTab: BottomTab.home),
          ),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: h * 0.01),

                        /// ---------- TOP BAR ----------
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainHomeScreen(
                                      initialTab: BottomTab.home,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Icon(Icons.arrow_back, size: 28),
                            ),
                            SizedBox(width: w * 0.03),
                            const Text(
                              "Logs",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              "assets/images/tms_logo.png",
                              height: 50,
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.02),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        SizedBox(height: h * 0.02),

                        /// ---------- DATE RANGE + FILTER ----------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _topButton(
                              icon: Icons.calendar_today_outlined,
                              title: _getDateRangeLabel(),
                              onTap: _pickDateRange,
                            ),
                            _topButton(
                              icon: Icons.filter_alt_outlined,
                              title: "Filter",
                              onTap: () {
                                setState(() {
                                  showStatusChips = !showStatusChips;
                                });
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.02),

                        /// ---------- FILTER TABS (show/hide with animation) ----------
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          firstChild: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _statusChip("All"),
                              _statusChip("Present"),
                              _statusChip("Late"),
                              _statusChip("Absent"),
                            ],
                          ),
                          secondChild: const SizedBox.shrink(),
                          crossFadeState: showStatusChips
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        ),

                        if (showStatusChips) SizedBox(height: h * 0.02),

                        /// ---------- API DATA LIST ----------
                        filteredData?.data == null ||
                                filteredData!.data!.isEmpty
                            ? const Center(child: Text("No logs found"))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredData!.data!.length,
                                itemBuilder: (_, i) {
                                  final item = filteredData!.data![i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: h * 0.02),
                                    child: _attendanceCard(item, h, w),
                                  );
                                },
                              ),

                        SizedBox(height: h * 0.13),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  /// ---------- TOP BUTTON ----------
  Widget _topButton({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EEF5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- FILTER CHIP ----------
  Widget _statusChip(String text) {
    final isSelected = selectedFilter == text;

    return GestureDetector(
      onTap: () => applyFilter(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// ---------- CARD ----------
  Widget _attendanceCard(Data item, double h, double w) {
    Color statusColor;

    if (item.status?.toLowerCase() == "present") {
      statusColor = Colors.green.shade300;
    } else if (item.status?.toLowerCase() == "late") {
      statusColor = Colors.orange.shade300;
    } else {
      statusColor = Colors.red.shade300;
    }

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DATE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  borderRadius: BorderRadius.circular(20),
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
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),

          SizedBox(height: h * 0.02),

          /// Punch In - Punch Out
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _punchColumn("Punch In", item.punchInTime ?? "-"),
              _punchColumn("Punch Out", item.punchOutTime ?? "-"),
            ],
          ),

          SizedBox(height: h * 0.02),
          Container(height: 1, color: Colors.grey.shade300),

          SizedBox(height: h * 0.015),

          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: Colors.grey.shade600),
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
    );
  }

  /// Punch Column
  Widget _punchColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
