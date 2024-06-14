// activity.dart

import 'package:flutter/material.dart';

class Activity {
  final String title;
  late final String description;
  final String location;
  final String date;
  String status;

  Activity({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.status,
  });
}
