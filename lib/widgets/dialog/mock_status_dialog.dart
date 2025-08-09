import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/device_constants.dart';
import '../../core/constants/string_constants.dart';
import '../../core/extension/context_extension.dart';
import '../../core/position/location_manager.dart';
import '../../helper/database_controller.dart';
import '../../view/home_view.dart';
import '../../viewModel/in_and_out_view_model.dart';
import '../button/dialogbutton.dart';
import 'custom_illegal_dialog.dart';
import 'snackbar.dart';

class MockStatusDialog {
  static MockStatusDialog instance = MockStatusDialog._init();
  MockStatusDialog._init();
  Future<bool> getMockStatus(MethodChannel platform) async {
    String mockException;
    bool mockTime = true;
    try {
      final bool result = await platform.invokeMethod('getMockStatus');
      mockException = 'Time Status $result % .';
      mockTime = result;
    } on PlatformException catch (e) {
      debugPrint("******************MockTime Exception**************");
      mockException = "Failed to get battery level: '${e.message}'.";
    }

    debugPrint(mockException);
    debugPrint(mockTime.toString());
    return mockTime;
  }

  _showIllegalDialog({
    required BuildContext context,
    required LocationManager locationManager,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String titleText,
    required String excuseText,
    required String cancelText,
    required TextEditingController controller,
    required String message,
    required DeviceInfoManager deviceInfo,
    required AlertCabilitySituation situation,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: context.colorScheme.primary,
      builder:
          (context) => AlertDialog(
            title: Text.rich(
              TextSpan(
                text: '$titleText\n',
                children: [
                  TextSpan(
                    text: excuseText,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: StringConstants.instance.description,
                suffixIcon: const Icon(Icons.edit),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DialogButton(
                    buttonText: StringConstants.instance.okey,
                    onPressed: CustomIllegalDialog.instance.alertCability(
                      scaffoldKey: scaffoldKey,
                      inAndOutVM: InAndOutViewModel(),
                      dataBaseController: DataBaseController(),
                      locationManager: locationManager,
                      cancelText: cancelText,
                      context: context,
                      controller: controller,
                      deviceInfo: deviceInfo,
                      excuseText: excuseText,
                      message: message,
                      titleText: titleText,
                      situation: situation,
                    ),
                    color: context.colorScheme.primary,
                  ),
                  DialogButton(
                    buttonText: StringConstants.instance.cancelButtonText,
                    onPressed: () {
                      Navigator.pop(context);
                      CustomSnackBar(
                        scaffoldKey.currentContext!,
                        cancelText,
                        backgroundColor: context.colorScheme.error,
                      );
                    },
                    color: context.colorScheme.error,
                  ),
                ],
              ),
            ],
          ),
    ).whenComplete(() {
      controller.clear();
    });
  }
}
