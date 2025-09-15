import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../../enums/enums.dart';
import '../../widget/dialog/dialog_factory.dart';

class LocationManager extends ChangeNotifier {
  Position? currentPosition;
  bool isMockLocation = false;
  StreamSubscription? _getPositionSubscription;
  determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!context.mounted) return;
    
    if (!serviceEnabled) {
      DialogFactory.create(
        context: context,
        type: DialogType.locationPermission,
        parameters: {'isEnabled': true, 'isMock': false},
      );
      return null;
    }
    
    permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (!context.mounted) return;
      if (permission == LocationPermission.denied) {
        DialogFactory.create(
          context: context,
          type: DialogType.locationPermission,
          parameters: {'isEnabled': false, 'isMock': false},
        );
        return null;
      }
    }
    
    if (!context.mounted) return;
    
    if (permission == LocationPermission.deniedForever) {
      DialogFactory.create(
        context: context,
        type: DialogType.locationPermission,
        parameters: {'isEnabled': false, 'isMock': false},
      );
      return null;
    }
    
    return await getCurrentLocation(context);
  }

  getCurrentLocation(BuildContext context) async {
    try {
      _getPositionSubscription?.cancel(); 
      _getPositionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10,
        ),
      ).listen(
        (Position position) async {
          if (!context.mounted) return;
          currentPosition = position;
          isMockLocation = position.isMocked;
          mockedCheck(context);
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Location stream error: $error');
          if (context.mounted) {
            if (error.toString().contains('denied')) {
              DialogFactory.create(
                context: context,
                type: DialogType.locationPermission,
                parameters: {'isEnabled': false, 'isMock': false},
              );
            } else {
              Fluttertoast.showToast(
                msg: "Konum alınamadı: ${error.toString()}",
                toastLength: Toast.LENGTH_LONG,
              );
            }
          }
        },
      );
    } catch (e) {
      debugPrint('getCurrentLocation error: $e');
      if (context.mounted) {
        Fluttertoast.showToast(
          msg: "Konum servisi başlatılamadı",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    }

    return currentPosition;
  }

  mockedCheck(context) {
    if (isMockLocation) {
      DialogFactory.create(
        context: context,
        type: DialogType.locationPermission,
        parameters: {'isEnabled': true, 'isMock': isMockLocation},
      );
    }
  }

  void disp() {
    _getPositionSubscription?.cancel();
    _getPositionSubscription = null;
  }
}
