import 'package:flutter/material.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swami Math Classes Student',
      home: const Scaffold(
        body: Center(child: Text('Student App Skeleton')),
      ),
    );
  }
}
