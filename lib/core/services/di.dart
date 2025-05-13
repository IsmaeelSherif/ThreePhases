import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_phases/features/admin/data/repositories/admin_repo.dart';
import 'package:three_phases/features/admin/data/repositories/admin_repo_impl.dart';
import 'package:three_phases/features/game/data/repo/game_repo.dart';
import 'package:three_phases/features/game/data/repo/game_repo_impl.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo_impl.dart';

Future<void> setup() async {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<IntiateGameRepo>(() => IntiateGameRepoImpl());
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  
  getIt.registerLazySingleton<GameRepo>(() => GameRepoImpl());
  final sharedPreferences = await SharedPreferences.getInstance();
   getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
   getIt.registerLazySingleton<AdminRepo>(() => AdminRepoImpl());
}
