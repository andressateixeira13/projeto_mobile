import 'package:flutter/material.dart';
import 'activity.dart';
import 'activity_details_page.dart';
import 'update_activity_page.dart';
import 'login_page.dart';
import 'activity_service.dart';
import 'user_session.dart';
import 'package:intl/intl.dart';

class ActivityListPage extends StatefulWidget {
  @override
  _ActivityListPageState createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  final ActivityService activityService = ActivityService();
  List<Activity> activities = [];
  List<Activity> filteredActivities = [];
  bool isLoading = true;
  late String token;
  late String cpf;
  String nome = '';
  String currentFilter = 'Atividades do dia';

  @override
  void initState() {
    super.initState();
    _initializeUserSession();
  }

  Future<void> _initializeUserSession() async {
    try {
      token = await UserSession.getToken() ?? '';
      cpf = await UserSession.getCpf() ?? '';
      nome = await UserSession.getNome() ?? '';
      await fetchActivities();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar sessão: $e')),
      );
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchActivities() async {
    setState(() { isLoading = true; });
    try {
      // NO ActivityService, adicione .timeout(Duration(seconds: 30))
      List<Activity> fetched = await activityService
          .fetchActivitiesByFuncionario(cpf, token);
      setState(() {
        activities = fetched;
        _applyFilter(currentFilter);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        activities = [];
        filteredActivities = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar atividades. Tente novamente.')),
      );
    }
  }

  void _applyFilter(String filter) {
    DateTime hoje = DateTime.now();
    DateTime diaLimpo = DateTime(hoje.year, hoje.month, hoje.day);

    setState(() {
      currentFilter = filter;
      filteredActivities = activities.where((a) {
        if (a.data == null) return false;
        DateTime d = DateTime.parse(a.data!);
        DateTime dClean = DateTime(d.year, d.month, d.day);
        switch (filter) {
          case 'Atividades do dia':
            return dClean == diaLimpo && (a.situacao == null || a.situacao!.isEmpty);
          case 'Atividades futuras':
            return dClean.isAfter(diaLimpo) && (a.situacao == null || a.situacao!.isEmpty);
          case 'Atividades atrasadas':
            return dClean.isBefore(diaLimpo) && (a.situacao == null || a.situacao!.isEmpty);
          case 'Atividades concluídas':
            return a.situacao != null && a.situacao!.isNotEmpty;
          default:
            return true;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $nome'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              UserSession.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 80,
              color: Colors.blueGrey,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ...[
              'Atividades do dia',
              'Atividades futuras',
              'Atividades concluídas',
              'Atividades atrasadas'
            ].map((f) => ListTile(
              title: Text(f),
              onTap: () {
                Navigator.pop(context);
                _applyFilter(f);
              },
            )),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredActivities.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nenhuma atividade encontrada.'),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchActivities,
              child: Text('Tentar novamente'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: filteredActivities.length,
        itemBuilder: (ctx, idx) {
          final a = filteredActivities[idx];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(a.nomeAtiv),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição: ${a.descricao}'),
                  Text('Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(a.data!))}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActivityDetailsPage(activity: a),
                  ),
                );
              },
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateActivityPage(
                        activityName: a.nomeAtiv, activity: a
                    ),
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
