import 'package:ems/Auth/Login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    /// Navigate to Login Screen after animation ends
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// MAIN LOGO
              // Image.asset(
              //   "assets/images/tms_logo.png",
              //   width: 220,
              //   height: 220,
              // ),
              SizedBox(height: h * 0.03),

              /// ANIMATED SCALE LOGO
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOutBack,
                ),
                child: Image.asset("assets/images/tms_logo.png", height: 60),
              ),

              SizedBox(height: h * 0.04),

              /// PROGRESS INDICATOR
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _controller.value,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
