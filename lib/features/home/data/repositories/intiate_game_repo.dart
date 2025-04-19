import 'package:three_phases/features/home/data/models/game_model.dart';

abstract class IntiateGameRepo {
  Future<void> hostGame(GameModel game);
  Future<GameModel> joinGame(String code);
  Future<GameModel> joinHostGame(String code);
}