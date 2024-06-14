import 'package:flutter/material.dart';
import 'activity_list_page.dart';
import 'password_recovery_page.dart';

class LoginPage extends StatelessWidget {
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
              Text(
                'Login',
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(labelText: 'Usuário'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ActivityListPage()),
                  );
                },
                child: Text('Login'),
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
