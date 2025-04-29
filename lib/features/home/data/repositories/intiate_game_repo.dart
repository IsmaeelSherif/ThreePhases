import 'package:dartz/dartz.dart';
import 'package:three_phases/core/utils/game_error.dart';
import 'package:three_phases/core/models/game_model.dart';

abstract class IntiateGameRepo {
  Future<Either<ErrorHandlar, Unit>> hostGame(GameModel game,{bool customWords=false});
  Future<Either<ErrorHandlar, GameModel>> joinGame(String code,{bool isHost=false});
  Future<Either<ErrorHandlar, String>> getLastGameCode(bool isHost);
}