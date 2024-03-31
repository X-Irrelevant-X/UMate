import 'package:flutter/material.dart';
import 'package:umate/view/login.dart';
import 'package:umate/pb_connect.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMate',
      debugShowCheckedModeBanner: false,
      home: LogIn(),
    );
  }
}
