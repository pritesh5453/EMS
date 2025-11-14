import 'package:ems/Dashboard/Dashboard_Screen.dart';
import 'package:ems/Dashboard/attendance_screen.dart';
import 'package:ems/Dashboard/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum BottomTab { home, attendance, profile }

final bottomTabProvider = StateProvider<BottomTab>((ref) => BottomTab.home);

class MainHomeScreen extends ConsumerStatefulWidget {
  final BottomTab initialTab;

  const MainHomeScreen({required this.initialTab});

  @override
  ConsumerState<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends ConsumerState<MainHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bottomTabProvider.notifier).state = widget.initialTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(bottomTabProvider);

    final pages = {
      BottomTab.home: const AttendanceHomeScreen(),
      BottomTab.attendance: const AttendanceLogsScreen(),
      BottomTab.profile: const EmployeeProfileScreen(),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: pages[selectedTab]!,
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 5,
            child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.white,
                  child: BottomNavigationBar(
                    currentIndex: BottomTab.values.indexOf(selectedTab),
                    onTap: (index) {
                      ref.read(bottomTabProvider.notifier).state =
                          BottomTab.values[index];
                    },
                    backgroundColor: Colors.white,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey.shade700,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    iconSize: 0,

                    items: [
                      /// HOME → Image asset
                      _navItemAsset(
                        "assets/icons/home.png",
                        selectedTab == BottomTab.home,
                      ),

                      /// ATTENDANCE → Flutter Icon
                      _navItemIcon(
                        Icons.fact_check_outlined,
                        selectedTab == BottomTab.attendance,
                      ),

                      /// PROFILE → Flutter Icon
                      _navItemIcon(
                        Icons.person_outline,
                        selectedTab == BottomTab.profile,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// IMAGE ICON TAB
  BottomNavigationBarItem _navItemAsset(String asset, bool isSelected) {
    return BottomNavigationBarItem(
      icon: CircleAvatar(
        radius: 22,
        backgroundColor: isSelected ? Colors.blue : Colors.transparent,
        child: Image.asset(
          asset,
          height: 22,
          width: 22,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      label: "",
    );
  }

  /// FLUTTER ICON TAB
  BottomNavigationBarItem _navItemIcon(IconData icon, bool isSelected) {
    return BottomNavigationBarItem(
      icon: CircleAvatar(
        radius: 22,
        backgroundColor: isSelected ? Colors.blue : Colors.transparent,
        child: Icon(
          icon,
          size: 24,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      label: "",
    );
  }
}

/// Dummy Screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text("Home"));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text("Profile"));
}
