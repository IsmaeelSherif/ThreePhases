import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/utils/game_error.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';

class IntiateGameRepoImpl implements IntiateGameRepo {
  final firestore = GetIt.instance.get<FirebaseFirestore>();

  @override
  Future<Either<ErrorHandlar, Unit>> hostGame(GameModel game) async {
    try {
      String code;
      bool codeExists;
        if (game.words.isEmpty) {
        // Check if categories list is not empty before querying
        if (game.categories.isEmpty) {
          return left(const ErrorHandlar(AppStrings.emptyCategories));
        }

        final words = await firestore
            .collection('words')
            .where('category', whereIn: game.categories.map((c) => c.getValue(GameLanguage.english).toLowerCase()).toList())
            .where('language', isEqualTo: game.language.value)
            .get();

        if (words.docs.isEmpty) {
          return left(const ErrorHandlar(AppStrings.noWordsFound));
        }

        final wordList = words.docs.map((doc) => doc.get('word') as String).toList();
        wordList.shuffle();
        if (wordList.length >= 40) {
          game.words = wordList.take(40).toList();
        } else {
          final List<String> gameWords = [];
          while (gameWords.length < 40) {
            wordList.shuffle();
            gameWords.addAll(wordList);
          }
          game.words = gameWords;
        }
      }
      do {
        // Generate a random 6-digit code
        final random = Random();
        code = (100000 + random.nextInt(900000)).toString();
        
        // Check if code exists
        final docSnapshot = await firestore.collection('games').doc(code).get();
        codeExists = docSnapshot.exists;
      } while (codeExists);
      game.code = code;
      
    

      await firestore
          .collection('games')
          .doc(code)
          .set(game.toMap());
      
      return right(unit);
    } catch (e) {
      return left(const ErrorHandlar(AppStrings.someThingWentWrong));
    }
  }

  @override
  Future<Either<ErrorHandlar, GameModel>> joinGame(String code) async {
    try {
      final gameDoc = await firestore.collection('games').doc(code).get();
      if (!gameDoc.exists) {
        return left(const ErrorHandlar(AppStrings.gameNotFoundError));
      }
      return right(GameModel.fromMap(gameDoc.data()!));
    } catch (e) {
      return left(const ErrorHandlar(AppStrings.someThingWentWrong));
    }
  }


}