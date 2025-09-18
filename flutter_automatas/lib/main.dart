// lib/main.dart
import 'package:flutter/material.dart';
import 'widgets/home_screen.dart';

void main() {
  runApp(const RegexApp());
}

class RegexApp extends StatelessWidget {
  const RegexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evaluador de Regex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter', // Fuente principal para texto normal
        textTheme: const TextTheme(
          // Títulos principales - Outfit
          headlineLarge: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
          ),

          // Títulos secundarios - Outfit
          titleLarge: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),

          // Texto del cuerpo - Inter
          bodyLarge: TextStyle(fontFamily: 'Inter'),
          bodyMedium: TextStyle(fontFamily: 'Inter'),
          bodySmall: TextStyle(fontFamily: 'Inter'),

          // Etiquetas - Inter
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
