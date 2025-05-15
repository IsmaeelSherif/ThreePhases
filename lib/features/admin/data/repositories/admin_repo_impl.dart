import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:three_phases/core/utils/enums/game_enums.dart';
import 'package:three_phases/core/utils/game_error.dart';
import 'package:three_phases/features/admin/data/models/unverified_word_model.dart';
import 'package:three_phases/features/admin/data/repositories/admin_repo.dart';

class AdminRepoImpl implements AdminRepo {
  @override
  Future<Either<ErrorHandlar, Unit>> verifyWords(UnverifiedWordModel newWords) async {
    try {
      final FirebaseFirestore firestore =
          GetIt.instance.get<FirebaseFirestore>();
      final CollectionReference words = firestore.collection('words');
      final CollectionReference unverifiedWords = firestore.collection('unverifiedWords');
      late int lastIndex;
      await words.orderBy('index', descending: true).limit(1).get().then((value) {
        if (value.docs.isNotEmpty) {
          lastIndex = value.docs.first['index'] as int;
        }
      });
      lastIndex++;
      for(int i = 0; i < newWords.words.length; i++){
       final Map<String, dynamic> wordData = {
      'category': GameCategory.playerWords.value,
      'index': lastIndex,
      "EnglishWord": newWords.words[i],
      "ArabicWord": "",
    };  
    await words.add(wordData);
    lastIndex++;
      }
      await unverifiedWords.doc(newWords.id).delete();
     
      return right(unit);
    } catch (e) {
      return left(ErrorHandlar(e.toString()));
    }
  }
  

@override
Future<Either<ErrorHandlar, List<UnverifiedWordModel>>> getUnverifiedWords() async {
  try {
    final FirebaseFirestore firestore = GetIt.instance.get<FirebaseFirestore>();
    final CollectionReference unverifiedWords = firestore.collection('unverifiedWords');
    final unverifiedWordsDocs = await unverifiedWords.get();
    final List<UnverifiedWordModel> unverifiedWordsList = unverifiedWordsDocs.docs.map((e) => UnverifiedWordModel.fromMap(e.data() as Map<String, dynamic>, e.id)).toList();
    return right(unverifiedWordsList);
  } catch (e) {
    return left(ErrorHandlar(e.toString()));
  }
}
}
