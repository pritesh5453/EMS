import 'package:ems/util/network_services.dart';
import 'package:flutter/material.dart';

class WifiBlockerScreen extends StatefulWidget {
  final Widget child; // your main app

  const WifiBlockerScreen({super.key, required this.child});

  @override
  State<WifiBlockerScreen> createState() => _WifiBlockerScreenState();
}

class _WifiBlockerScreenState extends State<WifiBlockerScreen> {
  bool isAllowed = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    checkWifi();
  }

  Future<void> checkWifi() async {
    bool ok = await NetworkService.isAllowedNetwork([
      "192.168.1.1",
      "192.168.0.1",
    ]);

    setState(() {
      isAllowed = ok;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ❌ WRONG WIFI → show full block screen
    if (!isAllowed) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                "Please connect to Company WiFi\nto use this application",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => checkWifi(),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    // ✔ CORRECT WIFI → load actual app
    return widget.child;
  }
}
