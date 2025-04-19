import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/utils/app_string_ar.dart';
import 'package:three_phases/core/utils/app_strings_en.dart';

part 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial()) {
  }

  // Language related properties and methods
  Map<String, String> _strings = {};
  Map<String, String> get strings => _strings;
  
  GameLanguage _currentLanguage = GameLanguage.english;
  GameLanguage get currentLanguage => _currentLanguage;

  void changeLanguage(GameLanguage language) {
    _currentLanguage = language;
    switch (language) {
      case GameLanguage.english:
        _strings = enData;
        emit(LanguageChangedEn());
        break;
      case GameLanguage.arabic:
        _strings = arData;
        emit(LanguageChangedAr());
        break;
    }
   
  }

}
