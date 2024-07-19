import 'package:flutter/material.dart';
import 'activity.dart';
import 'activity_details_page.dart';
import 'update_activity_page.dart';
import 'login_page.dart';
import 'activity_service.dart';
import 'user_session.dart';

class ActivityListPage extends StatefulWidget {
  @override
  _ActivityListPageState createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  final ActivityService activityService = ActivityService();
  List<Activity> activities = [];
  bool isLoading = true;
  late String token;
  late String cpf;

  @override
  void initState() {
    super.initState();
    _initializeUserSession();
  }

  Future<void> _initializeUserSession() async {
    try {
      token = await UserSession.getToken() ?? '';
      cpf = await UserSession.getCpf() ?? '';
      fetchActivities();
    } catch (e) {
      print('Error initializing user session: $e');
      // Handle error or show an appropriate message
    }
  }

  void fetchActivities() async {
    try {
      List<Activity> fetchedActivities = await activityService.fetchActivitiesByFuncionario(cpf, token);
      setState(() {
        activities = fetchedActivities;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception: Failed to load activities');
    }
  }

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
                  UserSession.clear();  // Clear user session
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : activities.isEmpty
          ? Center(child: Text('Nenhuma atividade encontrada.'))
          : ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(activities[index].nomeAtiv),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição: ${activities[index].descricao}'),
                  Text('Data: ${activities[index].data}'),
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
                    builder: (context) => UpdateActivityPage(activityName: activities[index].nomeAtiv, activity: activities[index]),
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
