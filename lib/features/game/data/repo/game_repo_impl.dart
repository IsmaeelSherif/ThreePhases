import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/game_error.dart';
import 'package:three_phases/features/game/data/repo/game_repo.dart';

class GameRepoImpl implements GameRepo {
  final firestore = GetIt.instance.get<FirebaseFirestore>();
  @override
  Future<Either<ErrorHandlar, Unit>> updateGame(GameModel game) async {
    try {
      await firestore.collection('games').doc(game.code).update(game.toMap());
      return right(unit);
    } catch (e) {
      final isConnectionError = e is FirebaseException && (e.code == 'unavailable' || e.code == 'network-error');
      return left(ErrorHandlar(
        isConnectionError 
          ? 'Connection error: Please check your internet'
          : 'Some thing when wrong',
      ));
    }
  }
}