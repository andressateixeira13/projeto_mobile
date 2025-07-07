import 'dart:convert';
import 'package:http/http.dart' as http;
import 'activity.dart';

class ActivityService {
  final String baseUrl = "http://10.0.2.2:8080";

  Future<String> fetchFuncionarioNomeByCpf(String cpf, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/funcionarios/$cpf'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['nome'] ?? 'Sem nome';
      } else {
        throw Exception('Erro ao buscar nome do funcionário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar nome: $e');
      throw Exception('Erro ao buscar nome');
    }
  }

  Future<List<Activity>> fetchActivitiesByFuncionario(String cpf, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/atividades/funcionario/$cpf'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 90));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Dados recebidos do backend:');
        for (var item in data) {
          print(item);
        }
        return data.map((json) => Activity.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception('Erro ao carregar atividades: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar atividades: $e');
      throw Exception('Erro ao buscar atividades');
    }
  }
}
