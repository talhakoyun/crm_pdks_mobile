import 'dart:io';

import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
=======
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/init/theme/theme_extensions.dart';
import '../core/widget/dialog/dialog_factory.dart';
import '../core/enums/dialog_type.dart';
>>>>>>> Stashed changes
import '../viewModel/auth_view_model.dart';
import '../widgets/text_input/profile_text_input.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

<<<<<<< Updated upstream
class _ProfileViewState extends State<ProfileView>
    with BaseSingleton, SizeSingleton {
  AuthViewModel authViewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (BuildContext context) => authViewModel,
      child: Consumer<AuthViewModel>(
        builder: (context, value, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  context.navigationOf.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: context.colorScheme.surface,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(msg: strCons.profileLoading);
                    value.getProfile(context, false);
                  },
                  icon: Icon(Icons.refresh, color: context.colorScheme.surface),
                ),
=======
class _ProfileViewState extends State<ProfileView> with BaseSingleton {
  late AuthViewModel authViewModel;

  @override
  void initState() {
    super.initState();
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, value, _) {
        return Scaffold(
          backgroundColor: context.colorScheme.onTertiaryContainer,
          body: Container(
            margin: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.errorContainer.withValues(
                            alpha: .1,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        value.gender == "Erkek" ? imgCons.male : imgCons.female,
                        height: 110.w,
                        width: 110.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                context.gapXS,
                Text(
                  value.userName ?? '',
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  value.department ?? '',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                context.gapXS,
                _buildCleanInfoCard(
                  context,
                  strCons.phone,
                  value.phone,
                  Icons.phone_outlined,
                ),
                context.gapXS,
                _buildCleanInfoCard(
                  context,
                  strCons.email,
                  value.email,
                  Icons.email_outlined,
                ),
                context.gapXS,
                _buildCleanInfoCard(
                  context,
                  strCons.gender,
                  value.gender,
                  Icons.person_outline,
                ),
                context.gapLG,
                _buildActionButtons(context, value),
>>>>>>> Stashed changes
              ],
            ),
            body: Container(
              margin: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  Image.asset(
                    value.gender == "Erkek" ? imgCons.male : imgCons.female,
                    height: sizeConfig.widthSize(context, 90),
                    width: sizeConfig.widthSize(context, 90),
                  ),
                  context.emptySizedHeightBoxLow2x,
                  Text(
                    value.userName!,
                    style: context.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    value.department!,
                    style: context.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  context.emptySizedHeightBoxHigh,
                  ProfileTextInput(
                    title: strCons.phone,
                    description: value.phone,
                    heightCon: Platform.isIOS
                        ? SizerUtil.height > 670
                              ? sizeConfig.heightSize(context, 60)
                              : sizeConfig.heightSize(context, 75)
                        : SizerUtil.height > 535
                        ? sizeConfig.heightSize(context, 65)
                        : sizeConfig.heightSize(context, 80),
                    icon: Icons.phone_iphone_rounded,
                    iconSize: 22.scalablePixel,
                  ),
                  context.emptySizedHeightBoxLow2x,
                  ProfileTextInput(
                    title: strCons.email,
                    description: value.email,
                    heightCon: Platform.isIOS
                        ? SizerUtil.height > 670
                              ? sizeConfig.heightSize(context, 60)
                              : sizeConfig.heightSize(context, 75)
                        : SizerUtil.height > 535
                        ? sizeConfig.heightSize(context, 65)
                        : sizeConfig.heightSize(context, 80),
                    icon: Icons.mail,
                    iconSize: 22.scalablePixel,
                  ),
                  context.emptySizedHeightBoxLow2x,
                  ProfileTextInput(
                    title: strCons.gender,
                    description: value.gender,
                    heightCon: Platform.isIOS
                        ? SizerUtil.height > 670
                              ? sizeConfig.heightSize(context, 60)
                              : sizeConfig.heightSize(context, 75)
                        : SizerUtil.height > 535
                        ? sizeConfig.heightSize(context, 65)
                        : sizeConfig.heightSize(context, 80),
                    icon: Icons.transgender_sharp,
                    iconSize: 22.scalablePixel,
                  ),
                  context.emptySizedHeightBoxLow2x,
                ],
              ),
            ),
<<<<<<< Updated upstream
=======
            child: Text(
              'Şifre Değiştir',
              style: Theme.of(context).primaryTextTheme.titleMedium,
            ),
          ),
        ),
        context.gapSM,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context, viewModel);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: context.colorScheme.error),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Çıkış Yap',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(
    BuildContext context,
    AuthViewModel viewModel,
  ) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmNewPasswordController =
        TextEditingController();

    DialogFactory.create(
      context: context,
      type: DialogType.changePassword,
      parameters: {
        'currentPasswordController': currentPasswordController,
        'newPasswordController': newPasswordController,
        'confirmNewPasswordController': confirmNewPasswordController,
        'onConfirm': () async {
          if (newPasswordController.text != confirmNewPasswordController.text) {
            if (context.mounted) {
              CustomSnackBar(
                context,
                'Yeni şifreler eşleşmiyor',
                backgroundColor: context.colorScheme.error,
              );
            }
            return;
          }

          if (newPasswordController.text.length < 6) {
            if (context.mounted) {
              CustomSnackBar(
                context,
                'Yeni şifre en az 6 karakter olmalıdır',
                backgroundColor: context.colorScheme.error,
              );
            }
            return;
          }

          Navigator.of(context).pop();

          final result = await viewModel.changePassword(
            currentPassword: currentPasswordController.text,
            newPassword: newPasswordController.text,
            newPasswordConfirmation: confirmNewPasswordController.text,
>>>>>>> Stashed changes
          );
        },
<<<<<<< Updated upstream
=======
        'onCancel': () {
          Navigator.of(context).pop();
        },
      },
    );
  }

  void _showLogoutConfirmationDialog(
    BuildContext context,
    AuthViewModel viewModel,
  ) {
    DialogFactory.create(
      context: context,
      type: DialogType.logoutConfirmation,
      parameters: {
        'onConfirm': () {
          Navigator.of(context).pop();
          viewModel.fetchLogout(context);
        },
        'onCancel': () {
          Navigator.of(context).pop();
        },
      },
    );
  }

  Widget _buildCleanInfoCard(
    BuildContext context,
    String title,
    String? description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.onError,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.errorContainer.withValues(alpha: .09),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colorScheme.onTertiaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: context.colorScheme.outline, size: 20),
          ),
          context.gapLG,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.bodyLarge),
                context.gapXS,
                Text(
                  description ?? '',
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
>>>>>>> Stashed changes
      ),
    );
  }
}
