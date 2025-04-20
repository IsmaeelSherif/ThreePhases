import 'package:three_phases/core/enums/game_enums.dart';

class GameModel {
  String code;
  List<GameCategory> categories;
  GameLanguage language;
  List<String> words;
  String? password;

  GameModel({
    required this.code,
    required this.categories,
    required this.language,
    this.words = const [],
     this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'categories': categories.map((c) => c.name).toList(),
      'language': language.name,
      'words': words,
      'password': password,
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
      password: map['password'],
    );
  }

  @override
  String toString() {
    return 'code: $code,\n\n categories: ${categories.map((c) => c.getValue(language)).toList()},\n\n\n language: ${language.value},\n\n words: $words,\n\n\n password: $password)';
  }
}
