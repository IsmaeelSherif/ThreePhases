import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:three_phases/core/services/di.dart';
import 'package:three_phases/core/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setup();
  // final WordIneserter wordIneserter = WordIneserter();
  // await wordIneserter.intiateWords();
  runApp(  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),);
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Three Phases',
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
