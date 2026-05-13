import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Stateless Logic Node Client                   |
\*----------------------------------------------*/
class BackendService {
  String? _cachedBaseUrl;

  /*----------------------------------------------*\
  |  Dynamically resolves the IP based on hardware |
  \*----------------------------------------------*/
  Future<String> get _baseUrl async {
    if (_cachedBaseUrl != null) return _cachedBaseUrl!;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.isPhysicalDevice) {
        // Real Android Phone (LAN IP)
        _cachedBaseUrl = 'http://172.26.39.112:3000';
      } else {
        // Android Emulator (Localhost Bridge)
        _cachedBaseUrl = 'http://10.0.2.2:3000';
      }
    } else {
      // Windows Desktop
      _cachedBaseUrl = 'http://localhost:3000';
    }

    return _cachedBaseUrl!;
  }

  Future<Map<String, dynamic>?> getStatus() async {
    try {
      final url = await _baseUrl;
      final response = await http.get(Uri.parse('$url/api/status'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Graceful fail for offline dev
    }
    return null;
  }

  /*----------------------------------------------*\
  |  Strict Bounds Analysis Engine                 |
  \*----------------------------------------------*/
  Future<Map<String, dynamic>?> analyzePace({
    required double delta,
  }) async {
    try {
      final url = await _baseUrl;
      final response = await http.post(
        Uri.parse('$url/api/engine/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'delta': delta,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Graceful fail
    }
    return null;
  }

  /*----------------------------------------------*\
  |  OS Trigger Engine                             |
  \*----------------------------------------------*/
  Future<bool> launchSystemTool(String target) async {
    try {
      final url = await _baseUrl;
      final response = await http.post(
        Uri.parse('$url/api/launch'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'target': target}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false; // Graceful fail
    }
  }
}