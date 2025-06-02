import 'package:flutter/material.dart';

class PasswordRecoveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redefinir Senha'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'CPF'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Senha Nova'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implementar
                  Navigator.pop(context);
                },
                child: Text('Redefinir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
