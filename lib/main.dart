import 'package:flutter/material.dart';
import 'login_page.dart';
import 'password_recovery_page.dart';
import 'activity_list_page.dart';
import 'activity_details_page.dart';
import 'update_activity_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Atividades',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/passwordRecovery': (context) => PasswordRecoveryPage(),
        '/activityList': (context) => ActivityListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/activityDetails') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return ActivityDetailsPage(activityName: args);
            },
          );
        }
        return null;
      },
    );
  }
}
