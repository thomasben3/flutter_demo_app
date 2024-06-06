import 'package:shared_preferences/shared_preferences.dart';

abstract class L10nService {

  static const String _languageCodeKey = 'language_code';

  /*
    Retrieve the locale from Shared Preferences. If it has never been set, then return null.
  */
  static Future<String?> getLocale() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    
    return sp.getString(_languageCodeKey);
  }

  static Future<void> setLocale(String languageCode) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    
    await sp.setString(_languageCodeKey, languageCode);
  }

}