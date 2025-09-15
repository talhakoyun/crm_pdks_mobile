import 'dart:convert';

import 'locale_manager.dart';
import '../../enums/preferences_keys.dart';

class AppCacheManager {
  static AppCacheManager? _instance;
  static AppCacheManager get instance {
    _instance ??= AppCacheManager._internal();
    return _instance!;
  }

  AppCacheManager._internal();

  final LocaleManager _localeManager = LocaleManager.instance;
  
  static const int _cacheExpiryMinutes = 5;

  Future<void> _setCache(PreferencesKeys key, PreferencesKeys timeKey, dynamic data) async {
    final dataJson = jsonEncode(data);
    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    
    await _localeManager.setStringValue(key, dataJson);
    await _localeManager.setStringValue(timeKey, currentTime);
  }

  T? _getCache<T>(PreferencesKeys key, PreferencesKeys timeKey, T Function(Map<String, dynamic>) fromJson) {
    try {
      final cachedData = _localeManager.getStringValue(key);
      final cachedTime = _localeManager.getStringValue(timeKey);
      
      if (cachedData.isEmpty || cachedTime.isEmpty) {
        return null;
      }
      
      final cacheTimestamp = int.tryParse(cachedTime);
      if (cacheTimestamp == null) {
        return null;
      }
      
      final now = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = Duration(milliseconds: now - cacheTimestamp);
      
      if (cacheAge.inMinutes > _cacheExpiryMinutes) {
        clearSpecificCache(key, timeKey);
        return null;
      }
      
      final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
      return fromJson(jsonData);
    } catch (e) {
      clearSpecificCache(key, timeKey);
      return null;
    }
  }

  bool _isCacheValid(PreferencesKeys timeKey) {
    try {
      final cachedTime = _localeManager.getStringValue(timeKey);
      if (cachedTime.isEmpty) return false;
      
      final cacheTimestamp = int.tryParse(cachedTime);
      if (cacheTimestamp == null) return false;
      
      final now = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = Duration(milliseconds: now - cacheTimestamp);
      
      return cacheAge.inMinutes <= _cacheExpiryMinutes;
    } catch (e) {
      return false;
    }
  }

  Future<void> setProfileCache(Map<String, dynamic> profileData) async {
    await _setCache(PreferencesKeys.PROFILE_CACHE, PreferencesKeys.PROFILE_CACHE_TIME, profileData);
  }

  Map<String, dynamic>? getProfileCache() {
    return _getCache<Map<String, dynamic>>(
      PreferencesKeys.PROFILE_CACHE, 
      PreferencesKeys.PROFILE_CACHE_TIME, 
      (json) => json,
    );
  }

  bool isProfileCacheValid() {
    return _isCacheValid(PreferencesKeys.PROFILE_CACHE_TIME);
  }

  Future<void> setInAndOutCache(List<dynamic> data) async {
    await _setCache(PreferencesKeys.INANDOUT_CACHE, PreferencesKeys.INANDOUT_CACHE_TIME, {'data': data});
  }

  List<dynamic>? getInAndOutCache() {
    return _getCache<List<dynamic>>(
      PreferencesKeys.INANDOUT_CACHE, 
      PreferencesKeys.INANDOUT_CACHE_TIME, 
      (json) => json['data'] as List<dynamic>,
    );
  }

  bool isInAndOutCacheValid() {
    return _isCacheValid(PreferencesKeys.INANDOUT_CACHE_TIME);
  }

  Future<void> setPermissionCache(List<dynamic> data) async {
    await _setCache(PreferencesKeys.PERMISSION_CACHE, PreferencesKeys.PERMISSION_CACHE_TIME, {'data': data});
  }

  List<dynamic>? getPermissionCache() {
    return _getCache<List<dynamic>>(
      PreferencesKeys.PERMISSION_CACHE, 
      PreferencesKeys.PERMISSION_CACHE_TIME, 
      (json) => json['data'] as List<dynamic>,
    );
  }

  bool isPermissionCacheValid() {
    return _isCacheValid(PreferencesKeys.PERMISSION_CACHE_TIME);
  }

  Future<void> clearSpecificCache(PreferencesKeys key, PreferencesKeys timeKey) async {
    await _localeManager.setStringValue(key, '');
    await _localeManager.setStringValue(timeKey, '');
  }

  Future<void> clearAllCache() async {
    await clearSpecificCache(PreferencesKeys.PROFILE_CACHE, PreferencesKeys.PROFILE_CACHE_TIME);
    await clearSpecificCache(PreferencesKeys.INANDOUT_CACHE, PreferencesKeys.INANDOUT_CACHE_TIME);
    await clearSpecificCache(PreferencesKeys.PERMISSION_CACHE, PreferencesKeys.PERMISSION_CACHE_TIME);
  }

  Future<void> optimizeCache() async {
    final allKeys = [
      [PreferencesKeys.PROFILE_CACHE, PreferencesKeys.PROFILE_CACHE_TIME],
      [PreferencesKeys.INANDOUT_CACHE, PreferencesKeys.INANDOUT_CACHE_TIME],
      [PreferencesKeys.PERMISSION_CACHE, PreferencesKeys.PERMISSION_CACHE_TIME],
    ];
    
    for (final keyPair in allKeys) {
      if (!_isCacheValid(keyPair[1])) {
        await clearSpecificCache(keyPair[0], keyPair[1]);
      }
    }
  }
}