// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/bank_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BankProvider(),
      child: const BankingApp(),
    ),
  );
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSA Banking Ledger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Light Grey background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0), // Corporate Blue
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF00BFA5), // Teal Accent
        ),
        fontFamily: 'Segoe UI', // Good standard font for Windows
      ),
      home: const LoginScreen(),
    );
  }
}