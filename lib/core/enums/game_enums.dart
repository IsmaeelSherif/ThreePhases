enum GameCategory {
  food,
  place,
  tools,
  technology,
  emotions,
  item,
  people,
  art,
  other;

  String getValue(GameLanguage language) {
    switch (language) {
      case GameLanguage.english:
        return _categoryValuesEn[this]!;
      case GameLanguage.arabic:
        return _categoryValuesAr[this]!;
    }
  }
}

const Map<GameCategory, String> _categoryValuesEn = {
  GameCategory.food: "Food",
  GameCategory.place: "Places",
  GameCategory.tools: "Tools",
  GameCategory.technology: "Technology",
  GameCategory.emotions: "Emotions",
  GameCategory.item: "Items",
  GameCategory.people: "People",
  GameCategory.art: "Art",
  GameCategory.other: "Other",
};

const Map<GameCategory, String> _categoryValuesAr = {
  GameCategory.food: "طعام",
  GameCategory.place: "أماكن",
  GameCategory.tools: "أدوات",
  GameCategory.technology: "تكنولوجيا",
  GameCategory.emotions: "عواطف",
  GameCategory.item: "أشياء",
  GameCategory.people: "أشخاص",
  GameCategory.art: "فن",
  GameCategory.other: "أخرى",
};

enum GameLanguage {
  english("English"),
  arabic("Arabic");

  final String value;
  const GameLanguage(this.value);
}
