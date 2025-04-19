import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo_impl.dart';

void setup() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<IntiateGameRepo>(() => IntiateGameRepoImpl());
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

}
