import 'package:flutter/material.dart';
import 'package:hangman/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            background: Color(0xffae0001), seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
