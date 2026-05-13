import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Stateless Logic Node Client                   |
\*----------------------------------------------*/
class BackendService {
  /*----------------------------------------------*\
  |  10.0.2.2 points to localhost for Android      |
  |  localhost points to localhost for Windows     |
  \*----------------------------------------------*/
  final String _baseUrl = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  Future<Map<String, dynamic>?> getStatus() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/status'));
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
      final response = await http.post(
        Uri.parse('$_baseUrl/api/engine/analyze'),
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
}
