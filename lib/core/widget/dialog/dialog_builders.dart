import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../../../viewModel/auth_view_model.dart';
import '../../constants/device_constants.dart';
import '../../constants/image_constants.dart';
import '../../constants/string_constants.dart';
import '../../enums/alert_capability_situation.dart';
import '../../extension/context_extension.dart';
import '../../init/size/size_extension.dart';
import '../../../viewModel/in_and_out_view_model.dart';
import '../../../widgets/text_input/custom_text_input.dart';
import '../../../widgets/button/dialogbutton.dart';
import '../../../widgets/snackbar.dart';
import 'base_dialog_builder.dart';
import 'dialog_components.dart';

class SuccessDialogBuilder extends BaseDialogBuilder {
  final String message;
  final String? title;
  final String? buttonText;
  final VoidCallback? onConfirm;

  SuccessDialogBuilder({
    required this.message,
    this.title,
    this.buttonText,
    this.onConfirm,
  });

  @override
  Color? getBackgroundColor(BuildContext context) => Colors.white;

  @override
  Widget buildTitle(BuildContext context) {
    return DialogTitleWidget(
      iconPath: ImageConstants.instance.success,
      title: title ?? StringConstants.instance.dialogSuccessTitle,
      message: message,
    );
  }

  @override
  Widget? buildContent(BuildContext context) => null;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      DialogActionsRow(
        actions: [
          DialogActionButton(
            text: buttonText ?? StringConstants.instance.dialogCloseText,
            onPressed: onConfirm ?? () => Navigator.of(context).pop(),
            isPrimary: true,
          ),
        ],
      ),
    ];
  }
}

class ErrorDialogBuilder extends BaseDialogBuilder {
  final String message;
  final String? title;
  final String? buttonText;
  final bool exitOnClose;
  final VoidCallback? onConfirm;

  ErrorDialogBuilder({
    required this.message,
    this.title,
    this.buttonText,
    this.exitOnClose = false,
    this.onConfirm,
  });

  @override
  Color? getBackgroundColor(BuildContext context) => Colors.white;

  @override
  Widget buildTitle(BuildContext context) {
    return DialogTitleWidget(
      iconPath: ImageConstants.instance.error,
      title: title ?? StringConstants.instance.dialogErrorTitle,
      message: message,
    );
  }

  @override
  Widget? buildContent(BuildContext context) => null;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      DialogActionsRow(
        actions: [
          DialogActionButton(
            text: buttonText ?? StringConstants.instance.dialogCloseText,
            onPressed:
                onConfirm ??
                () {
                  if (exitOnClose) {
                    exit(0);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
            isPrimary: true,
            isDestructive: true,
          ),
        ],
      ),
    ];
  }
}

class UpdateDialogBuilder extends BaseDialogBuilder {
  final String message;
  final String? title;
  final String? buttonText;
  final VoidCallback? onConfirm;

  UpdateDialogBuilder({
    required this.message,
    this.title,
    this.buttonText,
    this.onConfirm,
  });

  @override
  Widget buildTitle(BuildContext context) {
    return DialogTitleWidget(
      iconPath: ImageConstants.instance.error,
      title: title ?? StringConstants.instance.appName,
      message: message,
    );
  }

  @override
  Widget? buildContent(BuildContext context) => null;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      DialogActionsRow(
        actions: [
          DialogActionButton(
            text: buttonText ?? StringConstants.instance.dialogUpdateText,
            onPressed: onConfirm ?? () => Navigator.of(context).pop(),
            isPrimary: true,
          ),
        ],
      ),
    ];
  }
}

class InAndOutDialogBuilder extends BaseDialogBuilder {
  final String content;
  final String iconPath;
  final Color color;
  final VoidCallback onPressed;

  InAndOutDialogBuilder({
    required this.content,
    required this.iconPath,
    required this.color,
    required this.onPressed,
  });

  @override
  Color? getBackgroundColor(BuildContext context) =>
      context.colorScheme.onError;

  @override
  Widget? buildTitle(BuildContext context) => null;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 15.width,
          height: 15.width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7.5),
          ),
          child: Padding(
            padding: context.paddingLow,
            child: SvgPicture.asset(iconPath),
          ),
        ),
        context.emptySizedHeightBoxLow2x,
        Text(content, style: context.textTheme.bodyMedium),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      DialogActionsRow(
        alignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              fixedSize: Size(25.width, 5.height),
            ),
            child: Text(
              StringConstants.instance.approveButtonText,
              style: context.primaryTextTheme.bodyLarge,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              fixedSize: Size(25.width, 5.height),
            ),
            child: Text(
              StringConstants.instance.cancelButtonText,
              style: context.primaryTextTheme.bodyLarge,
            ),
          ),
        ],
      ),
    ];
  }
}

class QrTypeSelectionDialogBuilder extends BaseDialogBuilder {
  final VoidCallback onInPressed;
  final VoidCallback onOutPressed;

  QrTypeSelectionDialogBuilder({
    required this.onInPressed,
    required this.onOutPressed,
  });

  @override
  bool get barrierDismissible => true;

  @override
  double get elevation => 8.0;

  @override
  Color? getBackgroundColor(BuildContext context) =>
      context.colorScheme.onError;

  @override
  ShapeBorder getShape() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

  @override
  Widget? buildTitle(BuildContext context) => null;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.qr_code_scanner,
          size: 15.width,
          color: context.colorScheme.primary,
        ),
        context.emptySizedHeightBoxLow2x,
        Text(
          StringConstants.instance.qrTypeSelectionText,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onInPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.tertiaryContainer,
                  foregroundColor: context.colorScheme.onTertiaryContainer,
                  fixedSize: Size(double.infinity, 5.height),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  StringConstants.instance.qrEntryActionText,
                  style: context.primaryTextTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onOutPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.error,
                  foregroundColor: context.colorScheme.onErrorContainer,
                  fixedSize: Size(double.infinity, 2.height),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  StringConstants.instance.qrExitActionText,
                  style: context.primaryTextTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

class LocationPermissionDialogBuilder extends BaseDialogBuilder {
  final bool isEnabled;
  final bool isMock;

  LocationPermissionDialogBuilder({
    required this.isEnabled,
    required this.isMock,
  });

  @override
  Color? getBarrierColor(BuildContext context) => context.colorScheme.primary;
    @override
  Color? getBackgroundColor(BuildContext context) =>
      context.colorScheme.onError;


  @override
  ShapeBorder getShape() => const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  );

  @override
  Widget? buildTitle(BuildContext context) => null;

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            isMock
                ? Text.rich(
                    TextSpan(
                      text: StringConstants
                          .instance
                          .isMockLocationPermissionTitle,
                      style: context.textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: StringConstants
                              .instance
                              .isMockLocationPermissionDescription,
                          style: context.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : Text(
                    isEnabled
                        ? StringConstants.instance.isEnableLocationAlertText
                        : StringConstants.instance.isNotEnableLocationAlertText,
                    style: context.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ana buton (Tamam/Kapat)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (Platform.isIOS) {
                    exit(0);
                  } else {
                    SystemNavigator.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isMock 
                      ? context.colorScheme.error
                      : context.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  StringConstants.instance.okey,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (!isMock && !isEnabled) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Geolocator.openAppSettings();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Ayarlara Git",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ];
  }
}

class IllegalDialogBuilder extends BaseDialogBuilder {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final InAndOutViewModel inAndOutViewModel;
  final String titleText;
  final String excuseText;
  final String cancelText;
  final TextEditingController controller;
  final String message;
  final DeviceInfoManager deviceInfo;
  final AlertCapabilitySituation situation;

  IllegalDialogBuilder({
    required this.scaffoldKey,
    required this.inAndOutViewModel,
    required this.titleText,
    required this.excuseText,
    required this.cancelText,
    required this.controller,
    required this.message,
    required this.deviceInfo,
    required this.situation,
  });

  @override
  Color? getBarrierColor(BuildContext context) =>
      context.colorScheme.errorContainer.withValues(alpha: 0.4);

  @override
  Widget buildTitle(BuildContext context) {
    return Text.rich(
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
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return CustomTextInput(
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
      textInputType: TextInputType.text,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      DialogActionsRow(
        alignment: MainAxisAlignment.spaceEvenly,
        actions: [
          DialogButton(
            buttonText: StringConstants.instance.okey,
            onPressed: _getIllegalDialogAction(context),
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
    ];
  }

  @override
  Widget buildDialogWidget(BuildContext context) {
    return AlertDialog(
      shape: getShape(),
      backgroundColor: context.colorScheme.onError,
      elevation: elevation,
      title: buildTitle(context),
      content: buildContent(context),
      actions: buildActions(context),
    );
  }

  @override
  Future<T?> build<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: getBarrierColor(context),
      useSafeArea: useSafeArea,
      builder: (context) => buildDialogWidget(context),
    ).whenComplete(() {
      controller.clear();
    });
  }

  Function()? _getIllegalDialogAction(BuildContext context) {
    switch (situation) {
      case AlertCapabilitySituation.onlineInEvent:
        return () async {
          final errorColor = context.colorScheme.error;
          var data = await inAndOutViewModel.executeShiftProcedure(
            type: 1,
            longitude:
                inAndOutViewModel.locationManager.currentPosition!.longitude,
            latitude:
                inAndOutViewModel.locationManager.currentPosition!.latitude,
            deviceId: deviceInfo.deviceId,
            deviceModel: deviceInfo.deviceModel,
            context: context,
            isMockLocation: inAndOutViewModel.locationManager.isMockLocation,
            myNote: controller.text,
          );

          if (context.mounted) {
            Navigator.pop(context);
            if (data?.status == true) {
              CustomSnackBar(scaffoldKey.currentContext!, message);
            } else {
              CustomSnackBar(
                scaffoldKey.currentContext!,
                data?.message ?? StringConstants.instance.errorMessage,
                backgroundColor: errorColor,
              );
            }
          }
        };
      case AlertCapabilitySituation.onlineOutEvent:
        return () async {
          final errorColor = context.colorScheme.error;
          var data = await inAndOutViewModel.executeShiftProcedure(
            type: 2,
            longitude:
                inAndOutViewModel.locationManager.currentPosition!.longitude,
            latitude:
                inAndOutViewModel.locationManager.currentPosition!.latitude,
            deviceId: deviceInfo.deviceId,
            deviceModel: deviceInfo.deviceModel,
            context: context,
            isMockLocation: inAndOutViewModel.locationManager.isMockLocation,
            myNote: controller.text,
          );

          if (context.mounted) {
            Navigator.pop(context);
            if (data?.status == true) {
              CustomSnackBar(scaffoldKey.currentContext!, message);
            } else {
              CustomSnackBar(
                scaffoldKey.currentContext!,
                data?.message ?? StringConstants.instance.errorMessage,
                backgroundColor: errorColor,
              );
            }
          }
        };
      case AlertCapabilitySituation.lateInEvent:
        return () {
          Navigator.pop(context);
          final params = inAndOutViewModel;
          params.handleNoteSubmission(
            context: context,
            type: 1,
            note: controller.text.trim(),
          );
        };
      case AlertCapabilitySituation.earlyOutEvent:
        return () {
          Navigator.pop(context);
          final params = inAndOutViewModel;
          params.handleNoteSubmission(
            context: context,
            type: 2,
            note: controller.text.trim(),
          );
        };
    }
  }
}

class LogoutConfirmationDialogBuilder extends BaseDialogBuilder {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  LogoutConfirmationDialogBuilder({
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Color? getBackgroundColor(BuildContext context) =>
      context.colorScheme.onError;

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      StringConstants.instance.permissionLogout,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Text("${StringConstants.instance.exitTitle} \n ${StringConstants.instance.exitInfo}");
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      DialogActionsRow(
        alignment: MainAxisAlignment.spaceAround,
        actions: [
          DialogActionButton(
            text: StringConstants.instance.permissionCancel,
            onPressed: onCancel,
            isPrimary: false,
            isDestructive: false,
          ),
          DialogActionButton(
            text: StringConstants.instance.permissionLogout,
            onPressed: onConfirm,
            isPrimary: true,
            isDestructive: true,
          ),
        ],
      ),
    ];
  }
}

class ChangePasswordDialogBuilder extends BaseDialogBuilder {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmNewPasswordController;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  ChangePasswordDialogBuilder({
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmNewPasswordController,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Color? getBackgroundColor(BuildContext context) => Colors.white;

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      StringConstants.instance.permissionChangePassword,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return CustomTextInput(
                autofocus: true,
                labelText: StringConstants.instance.permissionCurrentPassword,
                obscureText: authViewModel.currentObscureText,
                controller: currentPasswordController,
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
                    Icons.lock_outlined,
                    color: context.colorScheme.surface,
                    size: 20.scalablePixel,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    authViewModel.togglePasswordVisibility(
                      fieldType: 'current',
                    );
                  },
                  icon: Icon(
                    authViewModel.currentObscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: context.colorScheme.surface,
                    size: 20,
                  ),
                ),
                maxLength: 150,
                textInputType: TextInputType.visiblePassword,
              );
            },
          ),
          const SizedBox(height: 16),
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return CustomTextInput(
                autofocus: true,
                labelText: StringConstants.instance.permissionNewPassword,
                obscureText: authViewModel.newObscureText,
                controller: newPasswordController,
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
                    Icons.lock_outlined,
                    color: context.colorScheme.surface,
                    size: 20.scalablePixel,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    authViewModel.togglePasswordVisibility(fieldType: 'new');
                  },
                  icon: Icon(
                    authViewModel.newObscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: context.colorScheme.surface,
                    size: 20,
                  ),
                ),
                maxLength: 150,
                textInputType: TextInputType.emailAddress,
              );
            },
          ),
          const SizedBox(height: 16),
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return CustomTextInput(
                autofocus: true,
                labelText:
                    StringConstants.instance.permissionConfirmNewPassword,
                obscureText: authViewModel.newConfirmObscureText,
                controller: confirmNewPasswordController,
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
                    Icons.lock_outlined,
                    color: context.colorScheme.surface,
                    size: 20.scalablePixel,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    authViewModel.togglePasswordVisibility(
                      fieldType: 'newConfirm',
                    );
                  },
                  icon: Icon(
                    authViewModel.newConfirmObscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: context.colorScheme.surface,
                    size: 20,
                  ),
                ),
                maxLength: 150,
                textInputType: TextInputType.emailAddress,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      DialogActionsRow(
        alignment: MainAxisAlignment.spaceAround,
        actions: [
          DialogActionButton(
            text: StringConstants.instance.permissionCancel,
            onPressed: onCancel,
            isPrimary: false,
            isDestructive: false,
          ),
          DialogActionButton(
            text: StringConstants.instance.permissionChange,
            onPressed: onConfirm,
            isPrimary: true,
            isDestructive: false,
          ),
        ],
      ),
    ];
  }
}
