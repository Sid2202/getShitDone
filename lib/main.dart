import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:wakelock/wakelock.dart';


void main() {
  Wakelock.enable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Jakarta'),
      home: HomePage(),
    );
  }
}
