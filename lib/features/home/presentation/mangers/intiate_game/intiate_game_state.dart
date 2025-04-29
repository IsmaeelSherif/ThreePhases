part of 'intiate_game_cubit.dart';

sealed class IntiateGameState {}

final class IntiateGameInitial extends IntiateGameState {}
final class IntiateGameLoading extends IntiateGameState {}
final class IntiateGameSuccess extends IntiateGameState {
  final GameModel game;
  final bool isHost;
  IntiateGameSuccess(this.game, {this.isHost=true});
}
final class GetLastHostedGameCodeSuccess extends IntiateGameState {
  final String code;
  GetLastHostedGameCodeSuccess(this.code);
}
final class GetLastJoinedGameCodeSuccess extends IntiateGameState {
  final String code;
  GetLastJoinedGameCodeSuccess(this.code);
}
final class GetLastHostedGameCodeError extends IntiateGameState {

}
final class GetLastJoinedGameCodeError extends IntiateGameState {

}

final class GetLastJoindeGameCodeSuccess extends IntiateGameState {
  final String code;
  GetLastJoindeGameCodeSuccess(this.code);
}

final class IntiateGameError extends IntiateGameState {
  final String message;
  IntiateGameError(this.message);
}
