import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:three_phases/core/firebase_utils/insert_words.dart';

import 'package:three_phases/core/utils/services/di.dart';
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
  final WordIneserter wordIneserter = WordIneserter();
  // await wordIneserter.intiateWords();
// await wordIneserter.insertMultipleLanguages(
//   {
//     'EnglishWord': ['Cat', 'Dog', 'Apple'],
//     'ArabicWord': ['قطة', 'كلب', 'تفاحة']
//   },
//   'TestCategory',
// );
// await wordIneserter.insertMultipleLanguages(
//   {
//     'EnglishWord': ['test1', 'test2', 'test3'],
//     'ArabicWord': ['تست1', 'تست2', 'تست3']
//   },
//   'TestCategory',
// );
// await  wordIneserter.insertNewLanguage(
//   ['Cat', 'Dog', 'Apple'],      
//   ['Chat', 'Chien', 'Pomme'],  
//   'FrenchWord',                
//   'TestCategory',              
// );

  
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
