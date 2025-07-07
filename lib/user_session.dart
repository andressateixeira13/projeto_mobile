import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> setCpf(String cpf) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cpf', cpf);
  }

  static Future<void> setNome(String nome) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', nome);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getCpf() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cpf');
  }

  static Future<String?> getNome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nome');
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('cpf');
    await prefs.remove('nome');
  }
}
