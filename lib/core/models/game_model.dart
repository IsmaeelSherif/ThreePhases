import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/models/words_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  String code;
  List<GameCategory> categories;
  int turnNumber ;
  int wordsCount;
  int turnTime;
  
  bool turnAvailable;
  bool turnFinished ;
  List<WordsModel> words;
  int lastWordIndex;
  String? password;
  DateTime? createdAt;
  List<int> doneWordIndexes;
  List<int> lastTurnDoneWords;
  GameModel({
    required this.code,
    required this.categories,
    this.words = const [],
     this.password,
     this.turnNumber=1,
     this.turnAvailable=false,
     this.turnFinished = false,
     required this.wordsCount,
     required this.turnTime,
     this.lastWordIndex = -1,
     this.doneWordIndexes = const [],
     this.createdAt,
     this.lastTurnDoneWords = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'categories': categories.map((c) => c.value).toList(),
      'words': words.map((word) => word.toMap()).toList(),
      'password': password,
      'turnNumber': turnNumber,
      'turnAvailable': turnAvailable,
      'turnFinished': turnFinished,
      'turnTime': turnTime,
      'wordsCount': wordsCount,
      'lastWordIndex': lastWordIndex ,
      'doneWordIndexes': doneWordIndexes,
      'createdAt':createdAt?? DateTime.now(),
      'lastTurnDoneWords': lastTurnDoneWords,

    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      code: map['code'] ?? '',
      categories: (map['categories'] as List?)
          ?.map((c) => GameCategory.values.firstWhere((e) => e.value == c))
          .toList() ?? [],
      words: (map['words'] as List?)
          ?.map((word) => WordsModel.fromMap(word))
          .toList() ?? [],
      password: map['password'],
      turnNumber: map['turnNumber'] ?? 1,
      turnAvailable: map['turnAvailable'] ?? false,
      turnFinished: map['turnFinished'] ?? false,
      turnTime: map['turnTime'] ?? 30,
      wordsCount: map['wordsCount'] ?? 10,
      lastWordIndex: map["lastWordIndex"]??0 ,
      doneWordIndexes: (map["doneWordIndexes"] as List?)?.map((i) => i as int).toList() ?? [],
      createdAt: (map["createdAt"] as Timestamp?)?.toDate(),
      lastTurnDoneWords: (map["lastTurnDoneWords"] as List?)?.map((i) => i as int).toList() ?? [],
    );
  }

  @override
  String toString() {
    return 'code: $code,\n\n categories: ${categories.map((c) => c.value).toList()},\n\n words: ${words.map((word) => word.toString()).toList()},\n\n\n password: $password';
  }
}
