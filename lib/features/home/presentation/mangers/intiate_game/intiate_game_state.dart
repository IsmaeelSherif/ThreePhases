part of 'intiate_game_cubit.dart';

sealed class IntiateGameState {}

final class IntiateGameInitial extends IntiateGameState {}
final class IntiateGameLoading extends IntiateGameState {}
final class IntiateGameSuccess extends IntiateGameState {
  final GameModel game;
  IntiateGameSuccess(this.game);
}
final class IntiateGameError extends IntiateGameState {
  final String message;
  IntiateGameError(this.message);
}
