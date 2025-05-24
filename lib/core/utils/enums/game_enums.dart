enum GameCategory {
  food("Food"),
  place("Place"),
  tools("Tools"),
  technology("Technology"),
  emotions("Emotions"),
  item("Item"),
  people("People"),
  art("Art"),
  other("Other"),
  customWords("Custom Words"),
;

  final String value;
  const GameCategory(this.value);
}





enum GameLanguage {
  english("English"),
  arabic("Arabic");

  final String value;
  const GameLanguage(this.value);
}
