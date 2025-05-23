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
    final FirebaseFirestore firestore = GetIt.instance.get<FirebaseFirestore>();
    final CollectionReference categoriesCollection = firestore.collection('allWords');
    final CollectionReference unverifiedWords = firestore.collection('unverifiedWords');

    final DocumentReference categoryDoc = categoriesCollection.doc(GameCategory.customWords.value);
    final CollectionReference subWordsCollection = categoryDoc.collection('categoryWords');

    // Get the last index in the customWords category
    int lastIndex = 0;
    final lastWordSnapshot = await subWordsCollection.orderBy('index', descending: true).limit(1).get();
    if (lastWordSnapshot.docs.isNotEmpty) {
      lastIndex = lastWordSnapshot.docs.first['index'] + 1;
    }

    for (int i = 0; i < newWords.words.length; i++) {
      final wordData = {
        'category': GameCategory.customWords.value,
        'index': lastIndex,
        'EnglishWord': newWords.words[i],
      };
      await subWordsCollection.doc(lastIndex.toString()).set(wordData);
      lastIndex++;
    }

    // Remove the unverified word entry
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
