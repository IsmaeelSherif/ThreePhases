class WordsModel {
  final String englishWord;
  final String arabicWord;
  final String category;
  WordsModel({
    required this.englishWord,
    required this.arabicWord,
    required this.category,
  });
  factory WordsModel.fromMap(Map<String, dynamic> map) {
    return WordsModel(
      englishWord: map['EnglishWord'] ?? '',
      arabicWord: map['ArabicWord'] ?? '',
      category: map['category'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'EnglishWord': englishWord,
      'ArabicWord': arabicWord,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'WordsModel{englishWord: $englishWord, arabicWord: $arabicWord, category: $category}';
  }
}