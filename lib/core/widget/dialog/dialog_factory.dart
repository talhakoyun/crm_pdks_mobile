import 'package:flutter/material.dart';

import '../../constants/device_constants.dart';
import '../../enums/enums.dart';
import '../../../viewModel/in_and_out_view_model.dart';
import 'dialog_builders.dart';
import 'base_dialog_builder.dart';

class DialogFactory {
  static final Map<DialogType, BaseDialogBuilder Function(Map<String, dynamic>)>
  _builders = {
    DialogType.success: (params) => SuccessDialogBuilder(
      message: params['message'] ?? '',
      title: params['title'],
      buttonText: params['buttonText'],
      onConfirm: params['onConfirm'],
    ),

    DialogType.error: (params) => ErrorDialogBuilder(
      message: params['message'] ?? '',
      title: params['title'],
      buttonText: params['buttonText'],
      exitOnClose: params['exitOnClose'] ?? false,
      onConfirm: params['onConfirm'],
    ),

    DialogType.warning: (params) => ErrorDialogBuilder(
      message: params['message'] ?? '',
      title: params['title'],
      buttonText: params['buttonText'],
      exitOnClose: params['exitOnClose'] ?? false,
      onConfirm: params['onConfirm'],
    ),

    DialogType.update: (params) => UpdateDialogBuilder(
      message: params['message'] ?? '',
      title: params['title'],
      buttonText: params['buttonText'],
      onConfirm: params['onConfirm'],
    ),

    DialogType.inAndOut: (params) => InAndOutDialogBuilder(
      content: params['content'] ?? '',
      iconPath: params['iconPath'] ?? '',
      color: params['color'] ?? Colors.blue,
      onPressed: params['onPressed'] ?? () {},
    ),

    DialogType.qrTypeSelection: (params) => QrTypeSelectionDialogBuilder(
      onInPressed: params['onInPressed'] ?? () {},
      onOutPressed: params['onOutPressed'] ?? () {},
    ),

    DialogType.illegal: (params) {
      final inAndOutViewModel =
          params['inAndOutViewModel'] as InAndOutViewModel?;
      final controller = params['controller'] as TextEditingController?;
      final deviceInfo = params['deviceInfo'] as DeviceInfoManager?;
      final situation = params['situation'] as AlertCapabilitySituation?;

      if (inAndOutViewModel == null ||
          controller == null ||
          deviceInfo == null ||
          situation == null) {
        throw ArgumentError('Illegal dialog için gerekli parametreler eksik');
      }

      return IllegalDialogBuilder(
        scaffoldKey: params['scaffoldKey'] ?? GlobalKey<ScaffoldState>(),
        inAndOutViewModel: inAndOutViewModel,
        titleText: params['titleText'] ?? '',
        excuseText: params['excuseText'] ?? '',
        cancelText: params['cancelText'] ?? '',
        controller: controller,
        message: params['message'] ?? '',
        deviceInfo: deviceInfo,
        situation: situation,
      );
    },

    DialogType.locationPermission: (params) => LocationPermissionDialogBuilder(
      isEnabled: params['isEnabled'] ?? false,
      isMock: params['isMock'] ?? false,
    ),
  };

  static Future<T?> create<T>({
    required BuildContext context,
    required DialogType type,
    Map<String, dynamic>? parameters,
  }) {
    final builderFactory = _builders[type];
    if (builderFactory == null) {
      throw ArgumentError('Desteklenmeyen dialog türü: $type');
    }

    final builder = builderFactory(parameters ?? {});
    return builder.build<T>(context);
  }
}
