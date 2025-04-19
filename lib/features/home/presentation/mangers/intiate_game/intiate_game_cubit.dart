import 'package:bloc/bloc.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';

part 'intiate_game_state.dart';

class IntiateGameCubit extends Cubit<IntiateGameState> {
  IntiateGameCubit(this.repo) : super(IntiateGameInitial());
  final IntiateGameRepo repo;
  Future<void> hostGame(GameModel game) async {
    emit(IntiateGameLoading());
    try {
      await repo.hostGame(game);
      emit(IntiateGameSuccess());
    } catch (e) {
      print(e);
      emit(IntiateGameError("Some Thing Went Wrong"));
    }
  }
}
