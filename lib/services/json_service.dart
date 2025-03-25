import 'dart:convert';

class JsonService {
  static Map<String, dynamic> decode(String source) {
    return json.decode(source) as Map<String, dynamic>;
  }

  static String encode(Map<String, dynamic> data) {
    return json.encode(data);
  }

  static List<Map<String, dynamic>> decodeList(String source) {
    return (json.decode(source) as List).cast<Map<String, dynamic>>();
  }
}