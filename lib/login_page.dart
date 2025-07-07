import 'package:flutter/material.dart';
import 'activity_list_page.dart';
import 'password_recovery_page.dart';
import 'auth_service.dart';
import 'user_session.dart';
import 'activity_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AuthService _authService = AuthService();
  final ActivityService _activityService = ActivityService();
  bool _isLoading = false;
  String _errorMessage = '';

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String cpf = _cpfController.text;
    final String senha = _senhaController.text;

    try {
      // Realiza login e salva token/cpf na UserSession
      await _authService.login(cpf, senha);
      final token = await UserSession.getToken() ?? '';

      // Busca o nome do funcionário
      final nome = await _activityService.fetchFuncionarioNomeByCpf(cpf, token);

      // Salva o nome na sessão
      await UserSession.setNome(nome);

      // Navega para a tela principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ActivityListPage()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Login falhou. Verifique suas credenciais.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Login', style: TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(height: 20),
              TextField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
              ),
              TextField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordRecoveryPage()),
                  );
                },
                child: Text('Recuperar Senha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
