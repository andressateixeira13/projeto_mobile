import 'dart:convert';
import 'package:http/http.dart' as http;
import 'activity.dart';

class ActivityService {
  final String baseUrl = "http://10.0.2.2:8080";

  Future<List<Activity>> fetchActivitiesByFuncionario(String cpf, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/atividades/funcionario/$cpf'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('entrando no 200');
        print('Dados recebidos do backend:');
        for (var item in data) {
          print(item); // <- imprime cada item do JSON como mapa
        }
        return data.map((json) => Activity.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities: $e');
      throw Exception('Error fetching activities');
    }
  }
}
