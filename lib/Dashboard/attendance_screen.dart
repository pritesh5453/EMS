import 'package:ems/Dashboard/Bottom_tab.dart';
import 'package:flutter/material.dart';

class AttendanceLogsScreen extends StatelessWidget {
  const AttendanceLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    List<Map<String, dynamic>> data = [
      {
        "name": "Pritesh Pawar",
        "date": "12-11-2025",
        "status": "Present",
        "punchIn": "08:56 Am",
        "punchOut": "06:11 Pm",
        "total": "09:15",
      },
      {
        "name": "Shivam Kshatriya",
        "date": "11-11-2025",
        "status": "Present",
        "punchIn": "08:56 Am",
        "punchOut": "06:11 Pm",
        "total": "09:15",
      },
    ];

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
          child: SingleChildScrollView(
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
                              builder: (context) =>
                                  MainHomeScreen(initialTab: BottomTab.home),
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
                      Image.asset("assets/images/tms_logo.png", height: 50),
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
                        title: "Date Range",
                      ),
                      SizedBox(width: w * 0.03),
                      _topButton(
                        icon: Icons.filter_alt_outlined,
                        title: "Filter",
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.02),

                  /// ---------- STATUS TABS ----------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusChip("All", true),
                      _statusChip("Present", false),
                      _statusChip("Late", false),
                      _statusChip("Absent", false),
                    ],
                  ),

                  SizedBox(height: h * 0.02),

                  /// ---------- ATTENDANCE CARDS LIST ----------
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (_, i) {
                      final item = data[i];
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
  Widget _topButton({required IconData icon, required String title}) {
    return Container(
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
    );
  }

  /// ---------- STATUS CHIPS ----------
  Widget _statusChip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ---------- ATTENDANCE CARD ----------
  Widget _attendanceCard(Map item, double h, double w) {
    Color statusColor;

    if (item["status"] == "Present") {
      statusColor = Colors.green.shade300;
    } else if (item["status"] == "Late") {
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
          /// NAME + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item["name"],
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
                  item["status"],
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
            item["date"],
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),

          SizedBox(height: h * 0.02),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _punchColumn("Punch In", item["punchIn"]),
              _punchColumn("Punch Out", item["punchOut"]),
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
                "Total Hours ${item["total"]}",
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

  /// Punch column widget
  Widget _punchColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
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
