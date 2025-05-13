import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/utils/game_error.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/models/words_model.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';

class IntiateGameRepoImpl implements IntiateGameRepo {
  final firestore = GetIt.instance.get<FirebaseFirestore>();
  final sharedPerf = GetIt.instance.get<SharedPreferences>();


   Future<void> _generateWord(GameModel game) async {
    game.words = [];
    late int lastIndex;

    await firestore
        .collection('words')
        .orderBy('index', descending: true)
        .limit(1)
        .get()
        .then((value) {
          if (value.docs.isNotEmpty) {
            lastIndex = value.docs.first['index'] as int;
          }
        });

    final Random random = Random();
    int wordIndex = random.nextInt(lastIndex + 1);
    final categoryList = game.categories.map((c) => c.value).toList();
    int rand = random.nextInt(4);
    switch (rand) {
      case 0:
        final snapshot =
            await firestore
                .collection('words')
                .where('category', whereIn: categoryList)
                .where('index', isGreaterThan: wordIndex)
                .limit(game.wordsCount)
                .get();
        game.words =
            snapshot.docs.map((doc) => WordsModel.fromMap(doc.data())).toList();
        if (game.words.length < game.wordsCount) {
          final snapshot2 =
              await firestore
                  .collection('words')
                  .where('category', whereIn: categoryList)
                  .where('index', isLessThan: wordIndex)
                  .limit(game.wordsCount - game.words.length)
                  .get();
          game.words.addAll(
            snapshot2.docs
                .map((doc) => WordsModel.fromMap(doc.data()))
                .toList(),
          );
        }
    
        break;
      case 1:
        final snapshot =
            await firestore
                .collection('words')
                .where('category', whereIn: categoryList)
                .where('index', isGreaterThan: wordIndex)
                .orderBy('EnglishWord')
                .limit(game.wordsCount)
                .get();

        game.words =
            snapshot.docs.map((doc) => WordsModel.fromMap(doc.data())).toList();
        if (game.words.length < game.wordsCount) {
          final snapshot2 =
              await firestore
                  .collection('words')
                  .where('category', whereIn: categoryList)
                  .where('index', isLessThan: wordIndex)
                  .orderBy('EnglishWord')
                  .limit(game.wordsCount - game.words.length)
                  .get();
          game.words.addAll(
            snapshot2.docs
                .map((doc) => WordsModel.fromMap(doc.data()))
                .toList(),
          );
        }
   
        break;
      case 2:
        final snapshot =
            await firestore
                .collection('words')
                .where('category', whereIn: categoryList)
                .where('index', isGreaterThan: wordIndex)
                .orderBy('ArabicWord')
                .limit(game.wordsCount)
                .get();

        game.words =
            snapshot.docs.map((doc) => WordsModel.fromMap(doc.data())).toList();
        if (game.words.length < game.wordsCount) {
          final snapshot2 =
              await firestore
                  .collection('words')
                  .where('category', whereIn: categoryList)
                  .where('index', isLessThan: wordIndex)
                  .orderBy('ArabicWord')
                  .limit(game.wordsCount - game.words.length)
                  .get();
          game.words.addAll(
            snapshot2.docs
                .map((doc) => WordsModel.fromMap(doc.data()))
                .toList(),
          );
        }
     
        break;
      case 3:
        final snapshot =
            await firestore
                .collection('words')
                .where('category', whereIn: categoryList)
                .where('index', isGreaterThan: wordIndex)
                .orderBy('index')
                .limit(game.wordsCount)
                .get();

        game.words =
            snapshot.docs.map((doc) => WordsModel.fromMap(doc.data())).toList();
        if (game.words.length < game.wordsCount) {
          final snapshot2 =
              await firestore
                  .collection('words')
                  .where('category', whereIn: categoryList)
                  .where('index', isLessThan: wordIndex)
                  .orderBy('index')
                  .limit(game.wordsCount - game.words.length)
                  .get();
          game.words.addAll(
            snapshot2.docs
                .map((doc) => WordsModel.fromMap(doc.data()))
                .toList(),
          );
        }
    
        break;
    }
  }

  @override
  Future<Either<ErrorHandlar, Unit>> hostGame(
    GameModel game, {
    bool customWords = false,
  }) async {
    try {
      String code;
      bool codeExists;

      if (!customWords) {
        if (game.categories.isEmpty) {
          return left(const ErrorHandlar(AppStrings.emptyCategories));
        }
        await _generateWord(game);
      if (game.words.isEmpty) {
        return left(const ErrorHandlar(AppStrings.noWordsFound));
      } else if (game.words.length < game.wordsCount) {
        return left(const ErrorHandlar(AppStrings.noEnoughWords));
      }
      }
      else{
       
        try{
         _insertToUnverifiedWords(game.words.map((e) => e.englishWord).toList());
      }
      // ignore: empty_catches
      catch(e){}
      }
      game.words.shuffle();
      // Generate and check code
      do {
        final random = Random();
        code = (100000 + random.nextInt(900000)).toString();
        final docSnapshot = await firestore.collection('games').doc(code).get();
        codeExists = docSnapshot.exists;
      } while (codeExists);

      game.code = code;
      await firestore.collection('games').doc(code).set(game.toMap());
      await sharedPerf.setString(AppStrings.lastHostedGameCode, code);
      return right(unit);
    } catch (e) {
      return left(const ErrorHandlar(AppStrings.someThingWentWrong));
    }
  }

  @override
  Future<Either<ErrorHandlar, GameModel>> joinGame(
    String code, {
    bool isHost = false,
  }) async {
    try {
      final gameDoc = await firestore.collection('games').doc(code).get();
      if (!gameDoc.exists) {
        final lastJoinedGame = sharedPerf.getString(
          AppStrings.lastJoinedGameCode,
        );
        final lastHostedGame = sharedPerf.getString(
          AppStrings.lastHostedGameCode,
        );
        if (code == lastJoinedGame) {
          sharedPerf.remove(AppStrings.lastJoinedGameCode);
        }
        if (code == lastHostedGame) {
          sharedPerf.remove(AppStrings.lastHostedGameCode);
        }
        return left(const ErrorHandlar(AppStrings.gameNotFoundError));
      }
      final game = GameModel.fromMap(gameDoc.data()!);

      if (!isHost) {
      await sharedPerf.setString(AppStrings.lastJoinedGameCode, code);
      }

      return right(game);
    } catch (e) {
 
      return left(const ErrorHandlar(AppStrings.someThingWentWrong));
    }
  }

  @override
  Future<Either<ErrorHandlar, String>> getLastGameCode(bool isHost) async {
    try {
      final code = sharedPerf.getString(
        isHost ? AppStrings.lastHostedGameCode : AppStrings.lastJoinedGameCode,
      );
      if (code == null) {
        return left(const ErrorHandlar(AppStrings.gameNotFoundError));
      }
      return right(code);
    } catch (e) {
      return left(const ErrorHandlar(AppStrings.someThingWentWrong));
    }
  }

Future<void> _insertToUnverifiedWords(List <String> newWords) async {
  final FirebaseFirestore firestore = GetIt.instance.get<FirebaseFirestore>();
  final CollectionReference unverifiedWords = firestore.collection('unverifiedWords');
 
    final Map<String, dynamic> wordData = {
      'date': DateTime.now(),
      'words': newWords,
    };
    await unverifiedWords.add(wordData);
  
}
}
