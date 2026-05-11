import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ResearchPresentationApp());
}

class ResearchPresentationApp extends StatelessWidget {
  const ResearchPresentationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'งานนำเสนอวิทยานิพนธ์',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}
