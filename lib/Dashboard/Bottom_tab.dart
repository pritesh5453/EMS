// main_home_screen.dart

import 'package:ems/Dashboard/Dashboard_Screen.dart';
import 'package:ems/Dashboard/attendance_screen.dart';
import 'package:ems/Dashboard/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// EMS App Bottom Tabs
enum BottomTab { home, attendance, profile }

/// Global bottom nav provider
final bottomTabProvider = StateProvider<BottomTab>((ref) => BottomTab.home);

class MainHomeScreen extends ConsumerStatefulWidget {
  final BottomTab? initialTab; // allow null

  const MainHomeScreen({super.key, this.initialTab});

  @override
  ConsumerState<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends ConsumerState<MainHomeScreen> {
  @override
  void initState() {
    super.initState();

    /// Set initial tab (or default)
    Future.microtask(() {
      ref.read(bottomTabProvider.notifier).state =
          widget.initialTab ?? BottomTab.home;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(bottomTabProvider);

    /// Pages for each tab
    final pages = {
      BottomTab.home: const AttendanceHomeScreen(),
      BottomTab.attendance: const AttendanceLogsScreen(),
      BottomTab.profile: const EmployeeProfileScreen(),
    };

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          /// Main page content
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: pages[selectedTab]!,
          ),

          /// Bottom navigation bar positioned
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
                      _navItemAsset(
                        "assets/icons/home.png",
                        selectedTab == BottomTab.home,
                      ),
                      _navItemIcon(
                        Icons.fact_check_outlined,
                        selectedTab == BottomTab.attendance,
                      ),
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

  /// IMAGE TAB ICON
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

  /// NORMAL ICON TAB
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
