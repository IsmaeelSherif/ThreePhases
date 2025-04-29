import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/features/game/data/repo/game_repo.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());
  final gameRepo = GetIt.instance.get<GameRepo>();
  void updateGame(GameModel game) async {
    emit(GameLoading());
   final result= await gameRepo.updateGame(game);
   result.fold(
      (error) => emit(GameError(message: error.message)),
      (_) => emit(GameUpdated()),
    );
  }
}
