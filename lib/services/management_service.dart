import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:igado_front/services/api.dart';

class ManagementService {
  final API _api = API();
  Future<dynamic> performManagement(Map data) async {
    var url = _api.url + 'management';
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    int statusCode = response.statusCode;
    if (statusCode == 201) {
      return jsonDecode(response.body);
    } else
      throw Exception('Failed to perform management. Error $statusCode');
  }
}
