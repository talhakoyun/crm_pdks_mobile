import 'package:flutter/material.dart';

import '../../core/constants/device_constants.dart';
import '../../core/constants/string_constants.dart';
import '../../core/extension/context_extension.dart';
import '../../core/init/size/size_extension.dart';
import '../../core/position/location_manager.dart';
import '../../view/home_view.dart';
import '../../viewModel/in_and_out_view_model.dart';
import '../../widgets/text_input/custom_text_input.dart';
import '../button/dialogbutton.dart';
import 'snackbar.dart';

class CustomIllegalDialog {
  static CustomIllegalDialog instance = CustomIllegalDialog._init();
  CustomIllegalDialog._init();
  showIllegalDialog({
    required BuildContext context,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required LocationManager locationManager,
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
      barrierColor: context.colorScheme.errorContainer.withValues(alpha: 0.4),
      builder: (context) => AlertDialog(
        title: Text.rich(
          TextSpan(
            text: '$titleText\n',
            children: [
              TextSpan(
                text: excuseText,
                style: context.textTheme.bodyMedium!.copyWith(fontSize: 14),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        content: CustomTextInput(
          autofocus: true,
          labelText: StringConstants.instance.description,
          obscureText: false,
          controller: controller,
          prefixIcon: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  style: BorderStyle.solid,
                  color: context.colorScheme.surface,
                  width: 0.75,
                ),
              ),
            ),
            child: Icon(
              Icons.description_outlined,
              color: context.colorScheme.surface,
              size: 20.scalablePixel,
            ),
          ),
          suffixIcon: const Icon(Icons.edit),
          maxLength: 150,
          textInputType: TextInputType.emailAddress,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DialogButton(
                buttonText: StringConstants.instance.okey,
                onPressed: alertCability(
                  scaffoldKey: scaffoldKey,
                  inAndOutVM: InAndOutViewModel(),
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

  Function()? alertCability({
    required BuildContext context,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required InAndOutViewModel inAndOutVM,
    required LocationManager locationManager,
    required String titleText,
    required String excuseText,
    required String cancelText,
    required TextEditingController controller,
    required String message,
    required DeviceInfoManager deviceInfo,
    required AlertCabilitySituation situation,
  }) {
    switch (situation) {
      case AlertCabilitySituation.onlineInEvent:
        return () async {
          var data = await inAndOutVM.inProcedure(
            longitude: locationManager.currentPosition!.longitude,
            latitude: locationManager.currentPosition!.latitude,
            deviceId: deviceInfo.deviceId,
            deviceModel: deviceInfo.deviceModel,
            context: context,
            isMockLocation: locationManager.isMockLocation,
            myNote: controller.text,
          );

          Navigator.pop(context);
          if (data['status']) {
            CustomSnackBar(scaffoldKey.currentContext!, message);
          } else {
            CustomSnackBar(
              scaffoldKey.currentContext!,
              data['message'],
              backgroundColor: context.colorScheme.error,
            );
          }
        };
      case AlertCabilitySituation.onlineOutEvent:
        return () async {
          var data = await inAndOutVM.outProcedure(
            longitude: locationManager.currentPosition!.longitude,
            latitude: locationManager.currentPosition!.latitude,
            deviceId: deviceInfo.deviceId,
            deviceModel: deviceInfo.deviceModel,
            context: context,
            isMockLocation: locationManager.isMockLocation,
            myNote: controller.text,
          );

          Navigator.pop(context);
          if (data['status']) {
            CustomSnackBar(scaffoldKey.currentContext!, message);
          } else {
            CustomSnackBar(
              scaffoldKey.currentContext!,
              data['message'],
              backgroundColor: context.colorScheme.error,
            );
          }
        };
      case AlertCabilitySituation.lateInEvent:
        return () {
          Navigator.pop(context);
          // Handle late in event with note
          CustomSnackBar(
            scaffoldKey.currentContext!,
            StringConstants.instance.successMessage2,
          );
        };
      case AlertCabilitySituation.earlyOutEvent:
        return () {
          Navigator.pop(context);
          // Handle early out event with note
          CustomSnackBar(
            scaffoldKey.currentContext!,
            StringConstants.instance.successMessage2,
          );
        };
    }
  }
}
