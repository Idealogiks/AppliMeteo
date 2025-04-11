import 'package:flutter/material.dart';
import 'package:mon_app/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/services/weather_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Météo',
      theme: ThemeData(
        primaryColor: const Color(0xFFD3D3D3), 
        scaffoldBackgroundColor: const Color(0xFFF8F8F8), 
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF5D5D5D), fontSize: 16), 
          bodyMedium: TextStyle(color: Color(0xFF7D7D7D), fontSize: 14), 
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB0B0B0), 
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Météo'),
    );
  }
}