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
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference categoriesCollection = firestore.collection('allWords');

    List<String> categories = game.categories.map((cat) => cat.value).toList();
    categories.shuffle();

    int totalWords = game.wordsCount;

    // Step 1: Generate random probabilities
    List<double> randomValues = List.generate(categories.length, (_) => Random().nextDouble());
    double total = randomValues.reduce((a, b) => a + b);
    Map<String, double> categoryProbabilities = {};

    for (int i = 0; i < categories.length; i++) {
      categoryProbabilities[categories[i]] = randomValues[i] / total;
    }


    // Step 2: Fetch random words from each category in parallel
    List<WordsModel> allWords = [];
    List<Future<void>> fetchFutures = [];
    
    categoryProbabilities.forEach((category, probability) {
      if(category==categories.last){
        return;
      }
      int wordsForCategory = (probability * totalWords).floor();
      fetchFutures.add(_fetchWordsForCategory(
        categoriesCollection,
        category,
        wordsForCategory,
        allWords,
      ));
    });

    await Future.wait(fetchFutures);
    final lastCategoryWords=totalWords-allWords.length;
   await Future.wait([_fetchWordsForCategory(
        categoriesCollection,
        categories.last,
        lastCategoryWords,
        allWords,
      
      )]);
    game.words = allWords;
  }

  Future<void> _fetchWordsForCategory(
    CollectionReference categoriesCollection,
    String category,
    int wordsForCategory,
    List<WordsModel> allWords,

  ) async {
    final subWordsCollection = categoriesCollection.doc(category).collection('categoryWords');

    // Get last index
    final snapshot = await subWordsCollection.orderBy('index', descending: true).limit(1).get();
    final int lastIndex = snapshot.docs.isNotEmpty ? snapshot.docs.first['index'] as int : 0;
    if(lastIndex<wordsForCategory){
      wordsForCategory=lastIndex;
    }
    // Generate unique random indexes
    final Set<int> randomIndexes = {};
    final random = Random();
    while (randomIndexes.length < wordsForCategory && lastIndex > 0) {
      randomIndexes.add(random.nextInt(lastIndex + 1));
    }

    // Fetch documents at those indexes
    final List<Future<DocumentSnapshot>> docFutures = randomIndexes.map((index) {
      return subWordsCollection.doc(index.toString()).get();
    }).toList();

    final docs = await Future.wait(docFutures);
    final words = docs
        .where((doc) => doc.exists)
        .map((doc) => WordsModel.fromMap(doc.data()! as Map<String, dynamic>))
        .toList();

    allWords.addAll(words);
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
      else{
        await sharedPerf.setString(AppStrings.lastHostedGameCode, code);
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
