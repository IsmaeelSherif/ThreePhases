import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';

part 'intiate_game_state.dart';

class IntiateGameCubit extends Cubit<IntiateGameState> {
  IntiateGameCubit(this.repo) : super(IntiateGameInitial());
  final IntiateGameRepo repo;

  Future<void> hostGame(GameModel game) async {
    emit(IntiateGameLoading());
    final result = await repo.hostGame(game);
    result.fold(
      (error) => emit(IntiateGameError(error.message)),
      (_) => emit(IntiateGameSuccess(game)),
    );
  }

  Future<void> joinGame(String code) async {
    emit(IntiateGameLoading());
    final result = await repo.joinGame(code);
    result.fold(
      (error) => emit(IntiateGameError(error.message)),
      (game) => emit(IntiateGameSuccess(game)),
    );
  }
}
