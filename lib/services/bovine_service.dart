import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:igado_front/services/api.dart';

class BovineService {
  final API _api = API();
  Future<dynamic> createBovine(Map data) async {
    var url = _api.url + 'bovine';
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
      throw Exception('Failed to create bovine. Error $statusCode');
  }

  Future<Bovine> fetchBovine(int id) async {
    final response = await http.get(_api.url + 'bovine/${id.toString()}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Bovine.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load bovine');
    }
  }

  Future<dynamic> deleteBovine(int id) async {
    print(id);
    final response = await http.delete(_api.url + 'bovine/${id.toString()}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return 200;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load bovine');
    }
  }

  Future<List<Bovine>> getAllBovine() async {
    final response = await http.get(_api.url + 'bovine');
    List<Bovine> bovines = [];
    if (response.statusCode == 200) {
      var decodedBody = jsonDecode(response.body);
      print(decodedBody['beef_cattles'].length);
      for (var bovine in decodedBody['beef_cattles']) {
        bovines.add(Bovine.fromJson({"data": bovine}));
      }
      for (var bovine in decodedBody['dairy_cattles']) {
        bovines.add(Bovine.fromJson({"data": bovine}));
      }
      return bovines;
    } else {
      throw Exception('Failed to load bovines');
    }
  }

  Future<dynamic> updateBovine(Map data, int id) async {
    var url = _api.url + 'bovine/${id.toString()}';
    print(data);
    var response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return jsonDecode(response.body);
    } else
      throw Exception('Failed to update bovine. Error $statusCode');
  }
}

class Bovine {
  final int bovineId;
  final String name;
  final String breed;
  final double actualWeight;
  final String dateOfBirth;
  final bool isBeefCattle;
  final String geneticalEnhancement;
  final bool isPregnant;
  final int farmId;
  final int batchOfBeef;

  Bovine(
      {this.bovineId,
      this.name,
      this.breed,
      this.actualWeight,
      this.dateOfBirth,
      this.isBeefCattle,
      this.geneticalEnhancement,
      this.isPregnant,
      this.farmId,
      this.batchOfBeef});

  factory Bovine.fromJson(Map<String, dynamic> json) {
    return Bovine(
        bovineId: json['data']['bovine_id'],
        name: json['data']['name'],
        breed: json['data']['breed'],
        actualWeight: json['data']['actual_weight'],
        dateOfBirth: json['data']['date_of_birth'],
        isBeefCattle: json['data']['is_beef_cattle'],
        geneticalEnhancement: json['data']['genetical_enhancement'],
        isPregnant: json['data']['is_pregnant'],
        farmId: json['data']['farm_id'],
        batchOfBeef: json['data']['batch_of_beef']);
  }
}
