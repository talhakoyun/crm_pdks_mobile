import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/init/theme/theme_extensions.dart';
import '../core/init/theme/app_constants.dart';
import '../viewModel/auth_view_model.dart';
import '../widgets/text_input/custom_text_input.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

<<<<<<< Updated upstream
class _RegisterViewState extends State<RegisterView>
    with BaseSingleton, SizeSingleton {
  final AuthViewModel authVM = AuthViewModel();
=======
class _RegisterViewState extends State<RegisterView> with BaseSingleton {
  late AuthViewModel authVM;

>>>>>>> Stashed changes
  @override
  void initState() {
    super.initState();
    authVM.init();
  }

  @override
  void dispose() {
    super.dispose();
    authVM.disp();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: authVM,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: context.colorScheme.onError,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text.rich(
              TextSpan(
                text: strCons.companyText,
                style: context.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: context.colorScheme.onTertiary,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: strCons.splashFooter,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onTertiary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                image: DecorationImage(
                  image: AssetImage(imgCons.splashBG),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: SizerUtil.height,
                  minWidth: SizerUtil.width,
                ),
                child: Column(
                  children: [buildLogoArea(context), buildFormArea(context)],
                ),
              ),
            ),
          ),
<<<<<<< Updated upstream
        );
      },
=======
          child: Container(
            constraints: BoxConstraints(maxHeight: 1.sh, minWidth: 1.sw),
            child: Column(
              children: [buildLogoArea(context), buildFormArea(context)],
            ),
          ),
        ),
      ),
>>>>>>> Stashed changes
    );
  }

  Widget buildLogoArea(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imgCons.logo, width: 100.w, height: 100.h),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Text.rich(
                TextSpan(
                  text:
                      "${strCons.splashText1} "
                      "${strCons.splashText2}",
                ),
                style: Theme.of(context).primaryTextTheme.bodyMedium!.copyWith(
                  letterSpacing: 0.75,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormArea(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: AppConstants.spacingLG,
          top: AppConstants.spacingMD,
          right: AppConstants.spacingLG,
          bottom: AppConstants.spacingMD,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.onError,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.radiusXL),
            topRight: Radius.circular(AppConstants.radiusXL),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              textArea(context),
              context.gapSM,
              nameWidget(context),
              context.gapSM,
              emailWidget(context),
              context.gapSM,
              passWidget(context),
              context.gapSM,
              passConfirmWidget(context),
              context.gapSM,
              btnWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget textArea(BuildContext context) {
    return Align(
      alignment: FractionalOffset.topLeft,
      child: Text.rich(
        textScaler: TextScaler.linear(1.03),
        TextSpan(
          text: "${strCons.signUp}\n",
          style: context.textTheme.headlineLarge!.copyWith(
            fontSize: 30.sp,
            color: context.colorScheme.tertiary,
            fontWeight: FontWeight.w500,
          ),
          children: <TextSpan>[
            TextSpan(
              text: strCons.signUpText,
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget nameWidget(BuildContext context) {
    return CustomTextInput(
      labelText: strCons.name,
      obscureText: false,
      controller: authVM.nameController,
      prefixIcon: Container(
        margin: EdgeInsets.all(AppConstants.spacingXS),
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingXS),
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
          Icons.person,
          color: context.colorScheme.surface,
          size: 20.sp,
        ),
      ),
      maxLength: 150,
      textInputType: TextInputType.emailAddress,
    );
  }

  Widget emailWidget(BuildContext context) {
    return CustomTextInput(
      labelText: strCons.email,
      obscureText: false,
      controller: authVM.emailController,
      prefixIcon: Container(
        margin: EdgeInsets.all(AppConstants.spacingXS),
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingXS),
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
          Icons.email,
          color: context.colorScheme.surface,
          size: 20.sp,
        ),
      ),
      maxLength: 150,
      textInputType: TextInputType.emailAddress,
    );
  }

  Widget passWidget(BuildContext context) {
    context.watch<AuthViewModel>().changeObsure;
    return CustomTextInput(
      labelText: strCons.password,
      obscureText: authVM.obscureText,
      controller: authVM.passController,
      textInputType: TextInputType.text,
      maxLength: 30,
      prefixIcon: Container(
        margin: EdgeInsets.all(AppConstants.spacingXS),
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingXS),
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
          Icons.lock,
          color: context.colorScheme.surface,
          size: 20.sp,
        ),
      ),
      suffixIcon: InkWell(
        onTap: () {
          context.read<AuthViewModel>().changeObsure();
        },
        child: Icon(
          authVM.obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: context.colorScheme.surface,
        ),
      ),
    );
  }

  Widget passConfirmWidget(BuildContext context) {
    context.watch<AuthViewModel>().changeObsure;
    return CustomTextInput(
      labelText: strCons.passwordConfirm,
      obscureText: authVM.obscureText,
      controller: authVM.passConfirmController,
      textInputType: TextInputType.text,
      maxLength: 30,
      prefixIcon: Container(
        margin: EdgeInsets.all(AppConstants.spacingXS),
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingXS),
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
          Icons.lock,
          color: context.colorScheme.surface,
          size: 20.sp,
        ),
      ),
      suffixIcon: InkWell(
        onTap: () {
          context.read<AuthViewModel>().changeObsure();
        },
        child: Icon(
          authVM.obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: context.colorScheme.surface,
        ),
      ),
    );
  }

  Widget btnWidget(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.onSecondary,
          fixedSize: Size(double.infinity, AppConstants.buttonHeight),
        ),
        onPressed: () {
          authVM.registerInputCheck(context);
        },
        child: Text(
          strCons.signUp,
          style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(
            letterSpacing: 1.0,
            color: context.colorScheme.onError,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
