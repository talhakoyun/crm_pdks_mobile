// ignore_for_file: avoid_print,unused_local_variable

import 'package:flutter/cupertino.dart';

import '../models/offline_qr_model.dart';
import '../models/offline_userdata_model.dart';
import 'database_helper.dart';

class DataBaseController {
  DatabaseHelper? dbHelper = DatabaseHelper.instance;
  Future<bool> isThereData() async {
    var data = await dbHelper!.getEventCount();

    print("********************User Data*******************");

    print(data[0]['COUNT (*)']);
    bool result = data[0]['COUNT (*)'] == 0 ? false : true;
    return result;
  }

  void insertDatabase(
      {required OfflineUserModel userdataModel,
      required BuildContext context}) {
    dbHelper!.insertData(userdataModel.offlineUserdataToMap());
  }

  void fetchUserData() async {
    var data = await dbHelper!.getUserOldEvent();

    print("************User DataBase Data****************");

    print(data);
  }

  Future<List<Map<String, dynamic>>> fetchIndata() async {
    var data = await dbHelper!.getUserInEvent();

    print("************UserIn DataBase Data****************");

    print(data);
    return data;
  }

  Future<List<Map<String, dynamic>>> fetchOutdata() async {
    var data = await dbHelper!.getUserOutEvent();

    print("************UserOut DataBase Data****************");

    print(data);
    return data;
  }

  Future<void> updateInAndOutdata(Map<String, Object?> data, int id) async {
    var data1 = await dbHelper!.updateData(data, id);

    print("************UserIn UpdatedDataBase Data****************");
    print(data);
  }

//region:QR AREA
  Future<bool> isThereQrData() async {
    var data = await dbHelper!.getQrEventCount();
    print("********************User Qr Data*******************");
    print(data[0]['COUNT (*)']);
    bool result = data[0]['COUNT (*)'] == 0 ? false : true;
    return result;
  }

  void insertQrDatabase(
      {required OfflineQrModel qrdataModel, required BuildContext context}) {
    dbHelper!.insertQrData(qrdataModel.offlineQRdataToMap());
  }

  void fetchQrUserData() async {
    var data = await dbHelper!.getUserOldEvent();
    print("************UserQr DataBase Data****************");
    print(data);
  }

  Future<List<Map<String, dynamic>>> fetchQrdata() async {
    var data = await dbHelper!.getQRProcessEvent();
    print("************UserQrIn DataBase Data****************");
    print(data);
    return data;
  }

  Future<void> updateQrData(Map<String, Object?> data, int id) async {
    var data1 = await dbHelper!.updateQrData(data, id);
    print("************UserQR UpdatedDataBase Data****************");
    print(data);
  }
//endregion
}
