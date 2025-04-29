import 'package:dartz/dartz.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/game_error.dart';

abstract class GameRepo {
  Future<Either<ErrorHandlar, Unit>> updateGame(GameModel game);
}
