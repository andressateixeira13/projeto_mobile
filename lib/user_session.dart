import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getCpf() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cpf');
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('cpf');
  }
}
