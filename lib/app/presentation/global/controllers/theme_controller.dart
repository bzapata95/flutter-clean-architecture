import 'package:flutter/foundation.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._darkMode);
  bool _darkMode;

  bool get darkMode => _darkMode;

  void onChanged(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }
}
