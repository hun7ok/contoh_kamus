import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Kamus.dart';

class Services {
  static const String url = 'http://api.yousmartdata.net/welcome/kamus';

  static Future<List<Kamus>> getUsers() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Kamus> list = parseUsers(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Kamus> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Kamus>((json) => Kamus.fromJson(json)).toList();
  }
}