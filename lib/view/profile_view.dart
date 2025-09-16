import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/widget/dialog/dialog_factory.dart';
import '../core/enums/dialog_type.dart';
import '../viewModel/auth_view_model.dart';
import '../widgets/snackbar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with BaseSingleton, SizeSingleton {
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
                        height: sizeConfig.widthSize(context, 110),
                        width: sizeConfig.widthSize(context, 110),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                context.emptySizedHeightBoxLow,
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
                context.emptySizedHeightBoxLow,
                _buildCleanInfoCard(
                  context,
                  strCons.phone,
                  value.phone,
                  Icons.phone_outlined,
                ),
                context.emptySizedHeightBoxLow,
                _buildCleanInfoCard(
                  context,
                  strCons.email,
                  value.email,
                  Icons.email_outlined,
                ),
                context.emptySizedHeightBoxLow,
                _buildCleanInfoCard(
                  context,
                  strCons.gender,
                  value.gender,
                  Icons.person_outline,
                ),
                context.emptySizedHeightBoxLow3x,
                _buildActionButtons(context, value),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, AuthViewModel viewModel) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showChangePasswordDialog(context, viewModel);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              strCons.permissionChangePassword,
              style: context.primaryTextTheme.titleMedium,
            ),
          ),
        ),
        context.emptySizedHeightBoxLow2x,
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
              StringConstants.instance.permissionLogout,
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
                strCons.permissionPasswordMismatch,
                backgroundColor: context.colorScheme.error,
              );
            }
            return;
          }

          if (newPasswordController.text.length < 6) {
            if (context.mounted) {
              CustomSnackBar(
                context,
                strCons.permissionPasswordLength,
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
          );

          Future.delayed(Duration.zero, () {
            if (context.mounted) {
              if (result.status!) {
                CustomSnackBar(
                  context,
                  result.message ?? strCons.permissionPasswordSuccess,
                  backgroundColor: context.colorScheme.tertiaryContainer,
                );
              } else {
                CustomSnackBar(
                  context,
                  result.message ?? strCons.permissionPasswordFailed,
                  backgroundColor: context.colorScheme.error,
                );
              }
            }
          });
        },
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
            child: Icon(icon, color: Colors.grey[600], size: 20),
          ),
          context.emptySizedWidthBoxLow3x,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.bodyLarge),
                const SizedBox(height: 4),
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
      ),
    );
  }
}
