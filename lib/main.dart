import 'package:flutter/material.dart';
import 'package:agendai/presentation/pages/initial.dart';
import 'package:agendai/presentation/pages/calendar.dart';

void main() => runApp(const MeetingApp());

class MeetingApp extends StatelessWidget {
  const MeetingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C8DFF),
          brightness: Brightness.dark,
          primary: const Color(0xFF4C8DFF),
          secondary: const Color(0xFF4C8DFF),
        ),
      ),
      home: const InitialPage(),
      routes: {
        '/calendar': (_) => const CalendarPage(),
      }
      // ou rotas:
      // routes: { InitialPage.route: (_) => const InitialPage(), },
    );
  }
}