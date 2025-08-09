
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class NetworkConnectivity {
  final Connectivity _connectivity = Connectivity();
  OverlayEntry? entry;
  bool first = true;
  bool internet = false;
  //DataBaseController dataBaseController = DataBaseController();
  NetworkConnectivity() {
    checkInternet();
  }

  void checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult[0] == ConnectivityResult.mobile) ||
        (connectivityResult[0] == ConnectivityResult.wifi)) {
      internet = true;
    }
    _connectivity.onConnectivityChanged.listen((event) {
      connectivityResult = event;
      if (connectivityResult[0] == ConnectivityResult.mobile) {
        internet = true;
        //dataBaseController.fetchUserData();
        //dataBaseController.fetchQrUserData();
      } else if (connectivityResult[0] == ConnectivityResult.wifi) {
        //dataBaseController.fetchUserData();
        //dataBaseController.fetchQrUserData();
        //dataBaseController.fetchIndata();
        //dataBaseController.fetchQrdata();
        internet = true;
      } else {
        internet = false;
      }
    });
    if (internet) {
      first = false;
      //dataBaseController.isThereData();
      //dataBaseController.isThereQrData();
    }
  }
}
