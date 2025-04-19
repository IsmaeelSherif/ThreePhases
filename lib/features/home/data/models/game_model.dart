import 'package:three_phases/core/enums/game_enums.dart';

class GameModel {
  final String code;
  final List<GameCategory> categories;
  final GameLanguage language;

  GameModel({
    required this.code,
    required this.categories,
    required this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'categories': categories.map((c) => c.name).toList(),
      'language': language.name,
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
    );
  }
}
