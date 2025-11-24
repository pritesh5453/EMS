import 'package:ems/API_Services/profile_services.dart';
import 'package:ems/Auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:ems/Dashboard/Bottom_tab.dart';
import 'package:ems/Model/profile_model.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  Profile? profileData;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() => loading = true);

    print("========================================");
    print("📌 EmployeeProfileScreen → FetchProfile() CALLED");
    print("========================================");

    final service = ProfileService();
    profileData = await service.fetchProfile();

    if (profileData == null) {
      print("❌ profileData is NULL");
    } else {
      print("✅ Profile Loaded Successfully");
      print("➡ Name: ${profileData!.data?.fullName}");
      print("➡ Email: ${profileData!.data?.email}");
    }

    setState(() => loading = false);
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
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF003A64)),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.015),

                      /// ---------- TOP BAR ----------
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                        child: Row(
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
                              child: const Icon(Icons.arrow_back, size: 26),
                            ),
                            SizedBox(width: w * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Employee Information",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Image.asset(
                              "assets/images/tms_logo.png",
                              height: 45,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: h * 0.015),
                      Divider(thickness: 1, color: Colors.grey.shade300),
                      SizedBox(height: h * 0.04),

                      /// ---------- PROFILE IMAGE ----------
                      Container(
                        clipBehavior: Clip.hardEdge,
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: profileData?.data?.photo == null
                            ? Image.asset(
                                "assets/images/user_temp.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                profileData!.data!.photo!,
                                fit: BoxFit.cover,
                              ),
                      ),

                      SizedBox(height: h * 0.03),

                      /// ---------- DETAILS ----------
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label("Name"),
                            _value(profileData?.data?.fullName ?? "-"),
                            _divider(),

                            _label("Email"),
                            _value(profileData?.data?.email ?? "-"),
                            _divider(),

                            _label("Phone Number"),
                            _value(profileData?.data?.phone ?? "-"),
                            _divider(),

                            _label("Department"),
                            _value(profileData?.data?.department ?? "-"),
                            _divider(),

                            _label("Designation"),
                            _value(profileData?.data?.position ?? "-"),
                            _divider(),

                            _label("Current Address"),
                            _value(profileData?.data?.address ?? "-"),
                            _divider(),

                            _label("Date of Birth"),
                            _value(profileData?.data?.dob ?? "-"),
                            _divider(),

                            _label("Joining Date"),
                            _value(profileData?.data?.startDate ?? "-"),
                            _divider(),

                            SizedBox(height: 20),

                            /// ---------- LOGOUT BUTTON ----------
                            _logoutButton(context),

                            SizedBox(height: h * 0.15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// LABEL
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 14),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black54, fontSize: 13),
      ),
    );
  }

  /// VALUE
  Widget _value(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// DIVIDER
  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Divider(thickness: 1, color: Colors.grey.shade300),
    );
  }

  /// LOGOUT BUTTON
  Widget _logoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutPopup(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: const [
            Icon(Icons.logout, size: 22, color: Colors.red),
            SizedBox(width: 12),
            Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// LOGOUT POPUP
  void _showLogoutPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 290,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFE4F9FF),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF004271), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Log Out?",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 7),
                const Text(
                  "Are you sure you want to log out of your account?",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        minimumSize: const Size(95, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),

                    const SizedBox(width: 15),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003A64),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(95, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Log Out"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
