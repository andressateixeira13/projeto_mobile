import 'package:flutter/material.dart';

import 'activity_details_page.dart';

class ActivityListPage extends StatelessWidget {
  final List<String> activities = ["Atividade 1", "Atividade 2", "Atividade 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Minhas Atividades'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(activities[index]),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailsPage(activityName: activities[index]),
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
