import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';
const String THEME = 'THEME';
//languages code
const String ENGLISH = 'en';
const String FRENCH = 'fr';
const String ARABIC = 'ar';
const String HINDI = 'hi';
//languages code
const String LIGHT = 'light';
const String DARK = 'dark';
Future<Locale> setLocal(String langCode)async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, langCode);
  return _locale(langCode);
}
Future<ThemeData> setTheme(String theme) async {
  print("lang333" +theme);
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(THEME, theme);
  if(theme=="dark")
    return ThemeData.dark().copyWith(
      primaryColor: Color(0xFFFFFFFF),
      //accentColor: Color(0xFF282B30),
      canvasColor: Color(0xFFFFD503),
      shadowColor: Color(0xFFFFFFFF),
      primaryColorDark:Color(0xFFAFD754),
    );
  else
    return ThemeData.light().copyWith(
      primaryColor: Color(0xFF7b6c94),
      //accentColor: Color(0xFF7b6c94),
      canvasColor: Color(0xFF7b6c94),
      shadowColor: Color(0xFF7b6c94),
      primaryColorDark:Color(0xFF7b6c94),
    );
}
Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? await getLocalPhoneLang();
  return _locale(languageCode);
}
Future<String> getLocalPhoneLang() async{
  // الحصول على لغة الجهاز
  String deviceLanguage = PlatformDispatcher.instance.locale.languageCode;
  String lang;
  if (deviceLanguage == "ar") {
    lang = "ar";
  } else if (deviceLanguage == "en") {
    lang = "en";
  } else if (deviceLanguage == "fr") {
    lang = "fr";
  } else if (deviceLanguage == "id") {
    lang = "id";
  } else {
    lang = "en";
  }

  await setLocal(lang);
  return lang;
}
 getCurrentLang() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  
  String languageCode = _prefs.getString(LAGUAGE_CODE)!;
  return languageCode;
}

Future<ThemeData> getTheme() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  print(_prefs.getString(THEME));
  String themeCode = _prefs.getString(THEME) ?? "light";
  if(themeCode=="dark")
    return ThemeData.dark().copyWith(
      primaryColor: Color(0xFFFFFFFF),
     /* accentColor: Color(0xFF282B30),
      canvasColor: Color(0xFFFFD503),
      shadowColor: Color(0xFFFFFFFF),
      primaryColorDark:Color(0xFFAFD754),*/


    );
  else
    return ThemeData.light().copyWith(
      primaryColor: Color(0xFF7b6c94),
      /*accentColor: Color(0xFFAFD754),
      canvasColor: Color(0xFFFFD503),
      shadowColor: Color(0xFF000000),
      primaryColorDark:Color(0xFF000000),*/



    );

}
Future<String> getThemeName() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  print(_prefs.getString(THEME));
  String themeCode ="light";// _prefs.getString(THEME) ?? "light";
  return themeCode;

}
Future<bool> getFirstLanch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey("firstLaunch")) {
    return false;
  } else {
    await prefs.setBool("firstLaunch", true);
    return true;
  }
}
Future<String> getLangCode() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  return languageCode;
}
Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case FRENCH:
      return Locale(FRENCH, "FR");
    case ARABIC:
      return Locale(ARABIC, "AR");
    default:
      return Locale(ENGLISH, 'US');
  }
}