import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';

class IntiateGameRepoImpl implements IntiateGameRepo {
  final firestore = GetIt.instance.get<FirebaseFirestore>(); 
  @override
  Future<void> hostGame(GameModel game) async {
      String code;
      bool codeExists;
      print("test");
      do {
        // Generate a random 6-digit code
        final random = Random();
        code = (100000 + random.nextInt(900000)).toString();
        
        // Check if code exists
        final docSnapshot = await firestore.collection('games').doc(code).get();
        codeExists = docSnapshot.exists;
      } while (codeExists);
      game.code = code;
      print("code generated");
      
      if(game.words.isEmpty){
          // Print categories for debugging
          print("Categories: ${game.categories.map((c) => c.name.toLowerCase()).toList()}");
          print("Language: ${game.language.value}");
          
          // Check if categories list is not empty before querying
          if (game.categories.isEmpty) {
            throw Exception("Categories list cannot be empty");
          }

          final words = await firestore
              .collection('words')
              .where('category', whereIn: game.categories.map((c) => c.getValue(GameLanguage.english).toLowerCase()).toList())
              .where('language', isEqualTo: game.language.value)
              .get();
          
          if (words.docs.isEmpty) {
            throw Exception("No words found for the selected categories and language");
          }

          print("Found ${words.docs.length} words");
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
          print("words added");
          }
          print("words added");
          await firestore
              .collection('games')
              .doc(code)
              .set(game.toMap());
     print("game created");
  }

  @override
  Future<GameModel> joinGame(String code) {
    throw UnimplementedError();
  }

  @override
  Future<GameModel> joinHostGame(String code) {
    throw UnimplementedError();
  }
}