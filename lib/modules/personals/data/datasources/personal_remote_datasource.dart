import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/personal_model.dart';

class PersonalRemoteDatasource {
  final _baseUrl = 'http://10.0.2.2:3000';

  Future<List<PersonalModel>> getPersonals() async {
    final response = await http.get(Uri.parse('$_baseUrl/personals'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
      return jsonList
          .map((jsonItem) => PersonalModel.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Erro ao carregar personais: ${response.statusCode}');
    }
  }
}