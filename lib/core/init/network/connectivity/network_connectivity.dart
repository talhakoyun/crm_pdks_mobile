import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class NetworkConnectivity {
  final Connectivity _connectivity = Connectivity();
  OverlayEntry? entry;
  bool first = true;
  bool internet = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  DateTime? _lastCheck;
  static const int _cacheSeconds = 2;

  NetworkConnectivity() {
    checkInternet();
  }

  void checkInternet() async {
    if (_lastCheck != null) {
      final diff = DateTime.now().difference(_lastCheck!).inSeconds;
      if (diff < _cacheSeconds) {
        return;
      }
    }

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      _updateInternetStatus(connectivityResult);
      _lastCheck = DateTime.now();

      // Listener''ı sadece bir kez bağla
      _connectivitySubscription?.cancel();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        event,
      ) {
        _updateInternetStatus(event);
        _lastCheck = DateTime.now();
      });
    } catch (e) {
      internet = false;
    }

    if (internet) {
      first = false;
    }
  }

  void _updateInternetStatus(List<ConnectivityResult> connectivityResult) {
    internet = connectivityResult.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
