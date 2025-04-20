import 'package:three_phases/core/enums/game_enums.dart';

class GameModel {
  String code;
  List<GameCategory> categories;

  List<String> words;
  String? password;

  GameModel({
    required this.code,
    required this.categories,
    this.words = const [],
     this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'categories': categories.map((c) => c.value).toList(),
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
      words: (map['words'] as List).map((word) => word as String).toList(),
      password: map['password'],
    );
  }

  @override
  String toString() {
    return 'code: $code,\n\n categories: ${categories.map((c) => c.value).toList()},\n\n words: $words,\n\n\n password: $password)';
  }
}
