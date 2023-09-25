import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../constant/language_manager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";

const String PREFS_KEY_DARK = "PREFS_KEY_DARK";

const String PREFS_KEY_IF_BOARDING_LOADED = "PREFS_KEY_IF_BOARDING_LOADED";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  static bool isLangChanged = false;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      // set english
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ENGLISH.getValue());
      isLangChanged = false;
    } else {
      // set arabic
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ARABIC.getValue());
      isLangChanged = true;
    }
  }

  Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      isLangChanged = true;
      return ARABIC_LOCAL;
    } else {
      isLangChanged = false;
      return ENGLISH_LOCAL;
    }
  }


  // Theme
  Future<void> changeTheme(bool themeValue) async {
    _sharedPreferences.setBool(PREFS_KEY_DARK, themeValue);
  }

  Future<bool> isThemeDark() async {
    return _sharedPreferences.getBool(PREFS_KEY_DARK) ?? false;
  }


  // if loaded Boarding

  Future<void> setBoardingLoaded() async {
    _sharedPreferences.setBool(PREFS_KEY_IF_BOARDING_LOADED, true);
  }

  Future<bool> isBoardingLoaded() async {
    return _sharedPreferences.getBool(PREFS_KEY_IF_BOARDING_LOADED) ?? false;
  }

}
