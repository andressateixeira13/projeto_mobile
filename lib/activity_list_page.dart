import 'package:flutter/material.dart';
import 'activity.dart';
import 'activity_details_page.dart';
import 'update_activity_page.dart';
import 'login_page.dart';

class ActivityListPage extends StatelessWidget {
  final List<Activity> activities = [
    Activity(title: "Limpeza", description: "Limpeza completa", location: "Sala 109, Predio F", date: "12/05/2024", status: ''),
    Activity(title: "Limpeza", description: "Tirar pó", location: "Sala 204, Predio F", date: "12/05/2024", status: ''),
    Activity(title: "Limpeza", description: "Retirar lixo", location: "Sala 208, Predio F", date: "12/05/2024", status: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Minhas Atividades'),
        backgroundColor: Colors.blueGrey,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'settings':
                // Navegue para a página de configurações
                  break;
                case 'logout':
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Configurações'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  'Usuário',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(activities[index].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição: ${activities[index].description}'),
                  Text('Local: ${activities[index].location}'),
                  Text('Data: ${activities[index].date}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailsPage(activity: activities[index]),
                  ),
                );
              },
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateActivityPage(activity: activities[index], activityName: '',),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
