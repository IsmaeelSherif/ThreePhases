import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';

part 'intiate_game_state.dart';

class IntiateGameCubit extends Cubit<IntiateGameState> {
  IntiateGameCubit(this.repo) : super(IntiateGameInitial());
  final IntiateGameRepo repo;

  Future<void> hostGame(GameModel game,{bool customWords=false}) async {
    emit(IntiateGameLoading());
    final result = await repo.hostGame(game, customWords: customWords);
    result.fold(
      (error) => emit(IntiateGameError(error.message)),
      (_) => emit(IntiateGameSuccess(game)),  
    );
  }

  Future<void> joinGame(String code,{bool isHost=false}) async {
    emit(IntiateGameLoading());
    final result = await repo.joinGame(code,isHost: isHost);
    result.fold(
      (error) => emit(IntiateGameError(error.message)),
      (game) => emit(IntiateGameSuccess(game,isHost: isHost)),
    );
  }

  Future<void> getLastHostedGameCode() async {
    emit(IntiateGameLoading());
    final result = await repo.getLastGameCode(true);
    result.fold(
      (error) => emit(GetLastHostedGameCodeError()),
      (code) => emit(GetLastHostedGameCodeSuccess(code)),
    );
  }

  Future<void> getLastJoinedGameCode() async {
    emit(IntiateGameLoading());
    final result = await repo.getLastGameCode(false);
    result.fold(
      (error) => emit(GetLastJoinedGameCodeError()),
      (code) => emit(GetLastJoinedGameCodeSuccess(code)),
    );
  }
}
