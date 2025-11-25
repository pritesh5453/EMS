import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NetworkService {
  static final _info = NetworkInfo();

  // Request all needed permissions (Android 12/13/14)
  static Future<void> ensurePermissions() async {
    await Permission.location.request();
    await Permission.locationWhenInUse.request();
    await Permission.nearbyWifiDevices.request();
  }

  // Fetch SSID + IPv4 safely (ColorOS / OneUI compatible)
  static Future<Map<String, String?>> getWifiDetails() async {
    await ensurePermissions();

    String? ssid = await _info.getWifiName();

    // Try both IPv4 APIs
    String? ipv4 = await _info.getWifiIP();
    if (ipv4 == null || ipv4.contains(":")) {
      // If still IPv6 → fallback attempt
      ipv4 = await _info.getWifiIPv6();
    }

    // Clean SSID
    if (ssid != null) ssid = ssid.replaceAll('"', '').trim();

    return {
      'ssid': ssid,
      'ipv4': ipv4,
    };
  }

  // Convert IP to gateway (192.168.1.x -> 192.168.1.1)
  static String? getDefaultGateway(String? ipv4) {
    if (ipv4 == null || ipv4.contains(":")) return null;

    final p = ipv4.split(".");
    if (p.length != 4) return null;

    return "${p[0]}.${p[1]}.${p[2]}.1";
  }

  // Check if the device is on the allowed WiFi network
  static Future<bool> isAllowedNetwork(List<String> allowedGateways) async {
    final wifi = await getWifiDetails();
    final ipv4 = wifi['ipv4'];

    if (ipv4 == null || ipv4.contains(":")) return false; // No IPv4

    final gateway = getDefaultGateway(ipv4);
    if (gateway == null) return false;

    return allowedGateways.contains(gateway);
  }
}