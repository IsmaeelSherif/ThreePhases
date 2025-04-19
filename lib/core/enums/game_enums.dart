enum GameCategory {
  food("Food"),
  place("Places"),
  tools("Tools"),
  technology("Technology"),
  emotions("Emotions"),
  item("Items"),
  people("People"),
  art("Art"),
  other("Other");

  final String value;
  const GameCategory(this.value);
}
enum GameCategoryAr {
  food("طعام"),
  place("أماكن"),
  tools("أدوات"),
  technology("تكنولوجيا"),
  emotions("عواطف"),
  item("أشياء"),
  people("أشخاص"),
  art("فن"),
  other("أخرى");

  final String value;
  const GameCategoryAr(this.value);
}

enum GameLanguage {
  english ("English"),
  arabic ("Arabic");

  final String value;
  const GameLanguage(this.value);
}
