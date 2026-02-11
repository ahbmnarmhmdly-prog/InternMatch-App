import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // استيراد صفحة الترحيب

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Training App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // يمكنك تغيير الخط لاحقاً
      ),
      home: const SplashScreen(), // تحديد شاشة البداية
    );
  }
}