import 'package:flutter/material.dart';
import 'activity.dart';
import 'update_activity_page.dart';

class ActivityDetailsPage extends StatelessWidget {
  final Activity activity;

  ActivityDetailsPage({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(activity.title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${activity.description}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Local: ${activity.location}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Data: ${activity.date}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateActivityPage(activity: activity, activityName: '',),
            ),
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
