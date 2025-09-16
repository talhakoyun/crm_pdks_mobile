import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/enums.dart';

class LocaleManager {
  static final LocaleManager _instance = LocaleManager._init();

  SharedPreferences? _preferences;
  static LocaleManager get instance => _instance;

  LocaleManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }
  static Future prefrencesInit() async {
    try {
      instance._preferences ??= await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint(
        '❌ LocaleManager: SharedPreferences initialization failed: $e',
      );
    }
  }

  Future<void> clearAll() async {
    await _preferences?.clear();
  }

  Future<void> clearAllSaveFirst() async {
    if (_preferences != null) {
      await _preferences?.clear();
      await setBoolValue(PreferencesKeys.IS_FIRST_APP, true);
    }
  }

  Future<void> setStringValue(PreferencesKeys key, String value) async {
    if (_preferences == null) {
      return;
    }

    try {
      await _preferences?.setString(key.toString(), value);
    } catch (e) {
      debugPrint('❌ LocaleManager: Error setting ${key.toString()}: $e');
    }
  }

  Future<void> setBoolValue(PreferencesKeys key, bool value) async {
    await _preferences?.setBool(key.toString(), value);
  }

  String getStringValue(PreferencesKeys key) {
    if (_preferences == null) {
      _initializePreferences();
      return '';
    }

    try {
      final value = _preferences?.getString(key.toString()) ?? '';
      return value;
    } catch (e) {
      debugPrint('❌ LocaleManager: Error getting ${key.toString()}: $e');
      return '';
    }
  }

  Future<void> _initializePreferences() async {
    try {
      _preferences = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint(
        '❌ LocaleManager: Failed to re-initialize SharedPreferences: $e',
      );
    }
  }

  bool getBoolValue(PreferencesKeys key) =>
      _preferences?.getBool(key.toString()) ?? false;

  // Yeni eklenen metod
  Future<void> setIntValue(PreferencesKeys key, int value) async {
    if (_preferences == null) {
      return;
    }

    try {
      await _preferences?.setString(key.toString(), value.toString());
    } catch (e) {
      debugPrint('❌ LocaleManager: Error setting ${key.toString()}: $e');
    }
  }

  // Yeni eklenen metod
  int getIntValue(PreferencesKeys key) {
    if (_preferences == null) {
      _initializePreferences();
      return 0;
    }

    try {
      final value = _preferences?.getString(key.toString()) ?? '0';
      return int.parse(value);
    } catch (e) {
      debugPrint('❌ LocaleManager: Error getting ${key.toString()}: $e');
      return 0;
    }
  }

  // Remove value metodu eklendi
  Future<void> removeValue(PreferencesKeys key) async {
    if (_preferences == null) {
      return;
    }

    try {
      await _preferences?.remove(key.toString());
    } catch (e) {
      debugPrint('❌ LocaleManager: Error removing ${key.toString()}: $e');
    }
  }
}
