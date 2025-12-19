import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  double _editorFontSize = 14.0;
  bool _autoSave = true;
  bool _wordWrap = true;

  ThemeMode get themeMode => _themeMode;
  double get editorFontSize => _editorFontSize;
  bool get autoSave => _autoSave;
  bool get wordWrap => _wordWrap;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    final themeIndex = prefs.getInt(AppConstants.themeKey) ?? 2; // Default to dark
    _themeMode = ThemeMode.values[themeIndex];
    
    _editorFontSize = prefs.getDouble(AppConstants.fontSizeKey) ?? 14.0;
    _autoSave = prefs.getBool(AppConstants.autoSaveKey) ?? true;
    _wordWrap = prefs.getBool(AppConstants.wordWrapKey) ?? true;
    
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.themeKey, mode.index);
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  Future<void> setEditorFontSize(double size) async {
    _editorFontSize = size.clamp(10.0, 24.0);
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.fontSizeKey, _editorFontSize);
  }

  Future<void> setAutoSave(bool value) async {
    _autoSave = value;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.autoSaveKey, value);
  }

  Future<void> setWordWrap(bool value) async {
    _wordWrap = value;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.wordWrapKey, value);
  }
}
