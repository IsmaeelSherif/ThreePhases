import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:three_phases/features/admin/data/models/unverified_word_model.dart';
import 'package:three_phases/features/admin/data/repositories/admin_repo.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());
  final AdminRepo _adminRepo = GetIt.instance.get<AdminRepo>();
  List<UnverifiedWordModel> unverifiedWords = [];
  Future<void> getUnverifiedWords() async {
    emit(AdminLoading());
    final result = await _adminRepo.getUnverifiedWords();
    result.fold(
      (l) => emit(AdminError(message: l.message)), 
      (r) {
        unverifiedWords = List.from(r)..sort((a, b) => b.date.compareTo(a.date));
        emit(AdminLoaded());
      }
    );
  }
  Future<void> verifyWords(UnverifiedWordModel words) async {
    emit(AdminVerifyWordsLoading());
    final result = await _adminRepo.verifyWords(words);
    result.fold((l) => emit(AdminVerifyWordsError(message: l.message)), (r) {
      unverifiedWords.remove(words);
      emit(AdminVerifyWordsSuccess());
    });
  }
  Future<void> updateWord(UnverifiedWordModel words,String word,String newWord) async {
    words.words[words.words.indexOf(word)] = newWord;
    emit(AdminLoaded());
  }
  Future<void> removeWord(UnverifiedWordModel words,String word) async {
 
      words.words.remove(word);
      emit(AdminLoaded());
  }
}