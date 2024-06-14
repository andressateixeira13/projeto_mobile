import 'package:flutter/material.dart';
import 'package:projeto_mobile/update_activity_page.dart';

class ActivityDetailsPage extends StatelessWidget {
  final String activityName;

  ActivityDetailsPage({required this.activityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(activityName),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Detalhes da Atividade',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Descrição detalhada da atividade.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateActivityPage(activityName: activityName),
                  ),
                );
              },
              child: Text('Atualizar Atividade'),
            ),
          ],
        ),
      ),
    );
  }
}
