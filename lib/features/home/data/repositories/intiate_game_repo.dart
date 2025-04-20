import 'package:dartz/dartz.dart';
import 'package:three_phases/core/utils/game_error.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';

abstract class IntiateGameRepo {
  Future<Either<ErrorHandlar, Unit>> hostGame(GameModel game);
  Future<Either<ErrorHandlar, GameModel>> joinGame(String code);
}