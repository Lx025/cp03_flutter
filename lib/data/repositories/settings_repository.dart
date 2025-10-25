import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _keyShowIntro = 'show_intro';

  Future<bool> getShowIntro() async {
    final prefs = await SharedPreferences.getInstance();
    // Retorna true por padrão (se a chave não existir)
    return prefs.getBool(_keyShowIntro) ?? true;
  }

  Future<void> setShowIntro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowIntro, value);
  }
}