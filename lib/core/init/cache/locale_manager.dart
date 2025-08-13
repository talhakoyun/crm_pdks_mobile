// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

enum PreferencesKeys {
  TOKEN,
  IS_FIRST_APP,
  ID,
  USERNAME,
  GENDER,
  OUTSIDE,
  ZONE,
  PHONE,
  EMAIL,
  DEPARTMENT,
  DEPARTMENTID,
  STARTDATE,
  STARTTDATE,
  ENDDATE,
  ENDTDATE,
  ROLE,
  COMPID,
  COMPNAME,
  COMPADDRESS,
  SHIFTNAME,
}

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
      print('✅ LocaleManager: SharedPreferences initialized successfully');

      // Test write/read to verify it's working
      await instance._preferences?.setString('test_key', 'test_value');
      final testValue = instance._preferences?.getString('test_key');
      print('✅ LocaleManager: Test write/read successful: $testValue');
      await instance._preferences?.remove('test_key');
    } catch (e) {
      print('❌ LocaleManager: SharedPreferences initialization failed: $e');
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
      print(
        '❌ LocaleManager: SharedPreferences is null when trying to set ${key.toString()}',
      );
      return;
    }

    try {
      await _preferences?.setString(key.toString(), value);
      print(
        '💾 LocaleManager: Set ${key.toString()} = ${value.length > 10 ? value.substring(0, 10) + "..." : value}',
      );

      // Verify the value was saved
      final savedValue = _preferences?.getString(key.toString());
      if (savedValue == value) {
        print('✅ LocaleManager: Value confirmed saved correctly');
      } else {
        print(
          '❌ LocaleManager: Value not saved correctly! Expected: $value, Got: $savedValue',
        );
      }
    } catch (e) {
      print('❌ LocaleManager: Error setting ${key.toString()}: $e');
    }
  }

  Future<void> setBoolValue(PreferencesKeys key, bool value) async {
    await _preferences?.setBool(key.toString(), value);
  }

  String getStringValue(PreferencesKeys key) {
    if (_preferences == null) {
      print(
        '❌ LocaleManager: SharedPreferences is null when trying to get ${key.toString()}',
      );
      // SharedPreferences null ise yeniden initialize et
      _initializePreferences();
      return '';
    }

    try {
      final value = _preferences?.getString(key.toString()) ?? '';
      print(
        '📖 LocaleManager: Get ${key.toString()} = ${value.isEmpty ? "EMPTY" : (value.length > 10 ? value.substring(0, 10) + "..." : value)}',
      );
      return value;
    } catch (e) {
      print('❌ LocaleManager: Error getting ${key.toString()}: $e');
      return '';
    }
  }

  // SharedPreferences'ı yeniden initialize etmek için helper method
  Future<void> _initializePreferences() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      print('✅ LocaleManager: SharedPreferences re-initialized');
    } catch (e) {
      print('❌ LocaleManager: Failed to re-initialize SharedPreferences: $e');
    }
  }

  bool getBoolValue(PreferencesKeys key) =>
      _preferences?.getBool(key.toString()) ?? false;
}
