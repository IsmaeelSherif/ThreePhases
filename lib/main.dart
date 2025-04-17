import 'package:flutter/material.dart';
import 'package:three_phases/core/utils/theme.dart';
import 'package:three_phases/features/home/presentation/views/home_view/home_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Three Phases',
      theme: AppTheme.lightTheme,
      home: const HomeView(),
    );
  }
}
