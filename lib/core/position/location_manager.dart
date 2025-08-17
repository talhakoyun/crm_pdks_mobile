import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../../widgets/dialog/custom_dialog.dart';

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
      CustomAlertDialog.locationPermissionAlert(
        context: context,
        isEnabled: true,
        isMock: false,
      );
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (!context.mounted) return;
    if (permission == LocationPermission.deniedForever) {
      CustomAlertDialog.locationPermissionAlert(
        context: context,
        isEnabled: false,
        isMock: false,
      );
    }
    return await getCurrentLocation(context);
  }

  getCurrentLocation(BuildContext context) async {
    try {
      _getPositionSubscription = Geolocator.getPositionStream().listen((
        Position position,
      ) async {
        if (!context.mounted) return;
        currentPosition = position;
        isMockLocation = position.isMocked;
        mockedCheck(context);
        notifyListeners();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Konumunuzu açın");
    }

    return currentPosition;
  }

  mockedCheck(context) {
    if (isMockLocation) {
      CustomAlertDialog.locationPermissionAlert(
        context: context,
        isEnabled: true,
        isMock: isMockLocation,
      );
    }
  }

  void disp() {
    _getPositionSubscription!.cancel();
  }
}
