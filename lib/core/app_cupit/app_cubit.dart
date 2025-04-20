// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:three_phases/core/enums/game_enums.dart';
// import 'package:three_phases/core/utils/app_string_ar.dart';
// import 'package:three_phases/core/utils/app_strings_en.dart';

// part 'app_states.dart';

// class AppCubit extends Cubit<AppStates> {
//   AppCubit() : super(AppInitial()) {
//     _strings = enData; // Set default English strings
//   }

//   late final SharedPreferences prefs;
  
//   // Language related properties and methods
//   Map<String, String> _strings = {};
//   Map<String, String> get strings => _strings;
  
//   GameLanguage _currentLanguage = GameLanguage.english;
//   GameLanguage get currentLanguage => _currentLanguage;
  
//   void changeLanguage(GameLanguage language) async {
//     _currentLanguage = language;
//     switch (language) {
//       case GameLanguage.english:
//         _strings = enData;
//         emit(LanguageChangedEn());
//         break;
//       case GameLanguage.arabic:
//         _strings = arData;
//         emit(LanguageChangedAr());
//         break;
//     }
//     await prefs.setInt('language', _currentLanguage.index);
//   }

//   Future<void> initLanguage() async {
//     prefs = GetIt.instance<SharedPreferences>();
//     final languageIndex = prefs.getInt('language') ?? 0;
//     _currentLanguage = GameLanguage.values[languageIndex];
//     changeLanguage(_currentLanguage);
//   }
// }
