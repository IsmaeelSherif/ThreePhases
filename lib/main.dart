import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/app_cupit/app_cubit.dart';
import 'package:three_phases/core/enums/game_enums.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..initLanguage(),
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Three Phases',
            theme: AppTheme.lightTheme,
            routerConfig: AppRoutes.router,
          );
        },
      ),
    );
  }
}
