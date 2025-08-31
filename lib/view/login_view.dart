import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/constants/navigation_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
import '../viewModel/auth_view_model.dart';
import '../widgets/text_input/custom_text_input.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with BaseSingleton, SizeSingleton {
  late AuthViewModel authVM;

  @override
  void initState() {
    super.initState();
    authVM = Provider.of<AuthViewModel>(context, listen: false);
    authVM.init();
  }

  @override
  void dispose() {
    super.dispose();
    authVM.disp();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                children: [
                  buildLogoArea(context),
                  buildFormArea(context, args),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogoArea(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imgCons.logo,
            width: sizeConfig.widthSize(context, 115),
            height: sizeConfig.heightSize(context, 145),
          ),
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
                style: context.primaryTextTheme.bodyMedium!.copyWith(
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

  Widget buildFormArea(BuildContext context, args) {
    return Expanded(
      flex: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 34,
          top: 20,
          right: 34,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.onError,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              textArea(context),
              context.emptySizedHeightBoxLow2x,
              emailWidget(context),
              context.emptySizedHeightBoxLow2x,
              passWidget(context),
              context.emptySizedHeightBoxLow3x,
              btnWidget(context),
              registerTextWidget(args),
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
          text: "${strCons.welcome}\n",
          style: context.textTheme.headlineLarge!.copyWith(
            fontSize: sizeConfig.scalablePixel(context, 30),
            color: const Color(0xffE75F0D), //context.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
          children: <TextSpan>[
            TextSpan(
              text: strCons.welcomeText,
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

  Widget emailWidget(BuildContext context) {
    return CustomTextInput(
      labelText: strCons.email,
      obscureText: false,
      controller: authVM.emailController,
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
          Icons.email,
          color: context.colorScheme.surface,
          size: 20.scalablePixel,
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
          Icons.lock,
          color: context.colorScheme.surface,
          size: 20.scalablePixel,
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
          fixedSize: Size(double.infinity, sizeConfig.heightSize(context, 50)),
        ),
        onPressed: () {
          authVM.controllerCheck(context);
        },
        child: Text(
          strCons.loginText,
          style: context.primaryTextTheme.bodyLarge!.copyWith(
            letterSpacing: 1.0,
            color: context.colorScheme.onError,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget registerTextWidget(args) {
    return Visibility(
      visible: args ?? false,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: GestureDetector(
          onTap: () {
            authVM.navigation.navigateToPage(
              path: NavigationConstants.REGISTER,
            );
          },
          child: Text.rich(
            TextSpan(
              text: strCons.dontAccount,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                color: context.colorScheme.onTertiary,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: strCons.newAccount,
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
