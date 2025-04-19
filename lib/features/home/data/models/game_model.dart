import 'package:three_phases/core/enums/game_enums.dart';

class GameModel {
   String code;
   List<GameCategory> categories;
   GameLanguage language;
   List<String> words;
  GameModel({
    required this.code,
    required this.categories,
    required this.language,
    this.words = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'categories': categories.map((c) => c.name).toList(),
      'language': language.name,
      'words': words,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      code: map['code'],
      categories: (map['categories'] as List)
          .map((c) => GameCategory.values.firstWhere((e) => e.name == c))
          .toList(),
      language:
          GameLanguage.values.firstWhere((e) => e.name == map['language']),
      words: (map['words'] as List).map((word) => word as String).toList(),
    );
  }
}
