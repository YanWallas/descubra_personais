import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/personal_model.dart';

class PersonalRemoteDatasource {
  final _baseUrl = 'http://10.0.2.2:3000'; // URL para o emulador Android studio acessar o localhost

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

  Future<bool> sendContactInterest({
    required String personalId,
    required String modality,
    required String frequency,
    required double estimatedPrice,
  }) async {
    final url = Uri.parse('$_baseUrl/contact-interest');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'personalId': personalId,
          'modality': modality,
          'frequency': frequency,
          'userName': 'Usuário App', 
          'estimatedPrice': estimatedPrice,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Erro de rede ao enviar interesse: $e');
      return false;
    }
  }
}