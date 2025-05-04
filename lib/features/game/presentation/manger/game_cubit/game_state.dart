part of 'game_cubit.dart';


sealed class GameState {}

final class GameInitial extends GameState {}
final class GameUpdated extends GameState {

}
final class GameLoading extends GameState {

}
final class GameError extends GameState {
  final String message;
  GameError({required this.message});
}

final class GameTurnStarted extends GameState {

}