import 'package:benebono_technical_ex/login/view/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technical sample',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 220, 110, 57),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 220, 110, 57)),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
