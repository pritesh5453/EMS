import 'package:flutter/material.dart';

class AttendanceHomeScreen extends StatelessWidget {
  const AttendanceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    /// Dummy list – You can replace with API data
    List<Map<String, dynamic>> attendanceList = [
      {
        "name": "Pritesh Pawar",
        "date": "12-11-2025",
        "status": "Present",
        "punchIn": "08:56 Am",
        "punchOut": "06:11 Pm",
        "total": "09:15",
      },
      {
        "name": "Yogesh Porshe",
        "date": "12-11-2025",
        "status": "Late",
        "punchIn": "08:56 Am",
        "punchOut": "06:11 Pm",
        "total": "09:15",
      },
      {
        "name": "Chetan Shelke",
        "date": "12-11-2025",
        "status": "Absent",
        "punchIn": "-",
        "punchOut": "-",
        "total": "00:00",
      },
      {
        "name": "Prathmesh Rathod",
        "date": "12-11-2025",
        "status": "Absent",
        "punchIn": "-",
        "punchOut": "-",
        "total": "00:00",
      },
      {
        "name": "Nilesh Pathak",
        "date": "12-11-2025",
        "status": "Absent",
        "punchIn": "-",
        "punchOut": "-",
        "total": "00:00",
      },
      {
        "name": "Sumit Pathak",
        "date": "12-11-2025",
        "status": "Absent",
        "punchIn": "-",
        "punchOut": "-",
        "total": "00:00",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: h * 0.02),

              /// ------------ TOP LOGO ------------
              Image.asset("assets/images/tms_logo.png", height: h * 0.08),

              SizedBox(height: h * 0.03),

              /// ------------ CHECK IN/OUT BUTTON ------------
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
                    onPressed: () {},
                    child: const Text(
                      "Check In/Out",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.03),

              /// ------------ LIST OF ATTENDANCE CARDS ------------
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  final item = attendanceList[index];
                  Color statusColor;

                  if (item["status"] == "Present") {
                    statusColor = Colors.green.shade300;
                  } else if (item["status"] == "Late") {
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NAME + STATUS BADGE
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
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),

                          SizedBox(height: h * 0.02),

                          /// Punch Details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Punch In",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: h * 0.005),
                                  Text(
                                    item["punchIn"],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Punch Out",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: h * 0.005),
                                  Text(
                                    item["punchOut"],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: h * 0.02),

                          /// Divider
                          Container(height: 1, color: Colors.grey.shade300),

                          SizedBox(height: h * 0.015),

                          /// Total Hours
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
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
}
