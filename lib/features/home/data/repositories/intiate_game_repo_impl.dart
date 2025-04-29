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

  List<int> _getUniqueRandomNumbers(
    int m,
    int n, {
    Set<int>? existingNumbers = const {},
  }) {
    if (m > n) {
      // If we need more numbers than available range, return all numbers up to n
      return List.generate(n, (i) => i);
    }

    if (m > n ~/ 2) {
      // If we need more than half the range, it's more efficient to generate all numbers
      // and remove random ones until we have m numbers
      final List<int> numbers = List.generate(n, (i) => i);
      numbers.shuffle();
      return numbers.take(m).toList();
    } else {
      // For smaller m, use Set to collect unique random numbers
      final rand = Random();
      final Set<int> result = {};

      while (result.length < m) {
        final num = rand.nextInt(n);
        if (!(existingNumbers?.contains(num) ?? false)) {
          result.add(num);
        }
      }

      return result.toList();
    }
  }

  Future<void> _generateWordsSecondChoice(GameModel game) async {
    game.words = [];

    // Check if categories list is not empty before querying

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

    final categoryList =
        game.categories.map((c) => c.value.toLowerCase()).toList();
    List<QueryDocumentSnapshot> allDocs = [];

    // Split wordIndexes into chunks and query Firestore in batches
    final wordIndexes = _getUniqueRandomNumbers(
      min(game.wordsCount - allDocs.length, lastIndex + 1),
      lastIndex + 1,
    );
    final chuckSize = 10 - categoryList.length;
    int index = 0;
    while (allDocs.length < game.wordsCount) {
      if (index == wordIndexes.length - 1) {
        wordIndexes.addAll(
          _getUniqueRandomNumbers(
            game.wordsCount - allDocs.length,
            lastIndex + 1,
            existingNumbers: wordIndexes.toSet(),
          ),
        );
      }
      List<int> chunk;
      if (index + chuckSize > wordIndexes.length) {
        chunk = wordIndexes.sublist(index - 1, wordIndexes.length);
        index = wordIndexes.length;
      } else {
        chunk = wordIndexes.sublist(index, index + chuckSize);
        index += chuckSize;
      }
      final snapshot =
          await firestore
              .collection('words')
              .where('category', whereIn: categoryList)
              .where('index', whereIn: chunk)
              .get();

      allDocs.addAll(snapshot.docs);
    }

    game.words =
        allDocs
            .take(game.wordsCount)
            .map(
              (doc) => WordsModel.fromMap(doc.data() as Map<String, dynamic>),
            )
            .toList();
  }

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
        game.words.shuffle();
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
        game.words.shuffle();
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
        game.words.shuffle();
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
        game.words.shuffle();
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
      }
      if (game.words.isEmpty) {
        return left(const ErrorHandlar(AppStrings.noWordsFound));
      } else if (game.words.length < game.wordsCount) {
        return left(const ErrorHandlar(AppStrings.noEnoughWords));
      }
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
      if (game.turnNumber > 3) {
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
        return left(const ErrorHandlar(AppStrings.gameFinished));
      }
      if (!isHost) {
        game.password = null;
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
}
