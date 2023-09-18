import 'package:flutter/foundation.dart';

import '../../../domain/repositories/preferences_repository.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(
    this._darkMode, {
    required this.preferencesRepository,
  });
  bool _darkMode;
  final PreferencesRepository preferencesRepository;

  bool get darkMode => _darkMode;

  void onChanged(bool darkMode) {
    _darkMode = darkMode;
    preferencesRepository.setDarkMode(darkMode);
    notifyListeners();
  }
}
