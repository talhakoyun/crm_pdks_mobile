import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/constants/navigation_constants.dart';
<<<<<<< Updated upstream
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
=======
import '../core/init/theme/theme_extensions.dart';
>>>>>>> Stashed changes
import '../viewModel/auth_view_model.dart';
import '../widgets/text_input/custom_text_input.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
<<<<<<< Updated upstream
    with BaseSingleton, SizeSingleton {
  final AuthViewModel authVM = AuthViewModel();
=======
    with BaseSingleton, TickerProviderStateMixin {
  late AuthViewModel authVM;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
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
    final args = ModalRoute.of(context)!.settings.arguments;
<<<<<<< Updated upstream
    return ChangeNotifierProvider.value(
      value: authVM,
      builder: (context, snapshot) {
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
=======
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.secondary,
                  context.colorScheme.primary.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = constraints.maxHeight;
                  final isSmallScreen = screenHeight < 600;
                  final hasKeyboard = keyboardHeight > 0;

                  return CustomScrollView(
                    physics: hasKeyboard
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: buildBrandArea(
                                context,
                                hasKeyboard || isSmallScreen,
                              ),
                            ),
                            Expanded(child: buildLoginCard(context, args)),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: (hasKeyboard || isSmallScreen) ? 0 : null,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: (hasKeyboard || isSmallScreen)
                                    ? 0.0
                                    : 1.0,
                                child: buildFooter(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBrandArea(BuildContext context, bool isCompact) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: isCompact ? 15 : 40,
              horizontal: 20,
            ),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isCompact ? 50 : 100,
                  height: isCompact ? 50 : 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset(imgCons.logo, fit: BoxFit.contain),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isCompact ? 5 : 20,
                ),
                if (!isCompact) ...[
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        context.colorScheme.surface,
                        context.colorScheme.tertiary,
                        context.colorScheme.surface,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      strCons.appName,
                      style: context.textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: context.colorScheme.surface,
                      ),
                    ),
                  ),
                  context.gapSM,
                  Text(
                    "${strCons.splashText1} ${strCons.splashText2}",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: context.colorScheme.surface.withValues(alpha: 0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ] else ...[
                  Text(
                    strCons.appName,
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.surface,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                  child: Column(
                    children: [
                      buildLogoArea(context),
                      buildFormArea(context, args),
                    ],
                  ),
=======
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: context.colorScheme.surface.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.shadow.withValues(
                          alpha: 0.1,
                        ),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildWelcomeText(context),
                        context.gapLG,
                        buildEmailField(context),
                        context.gapMD,
                        buildPasswordField(context),
                        context.gapXXL,
                        buildLoginButton(context),
                        buildRegisterText(context, args),
                      ],
                    ),
                  ),
>>>>>>> Stashed changes
                ),
              ),
            ),
          ),
        );
      },
    );
  }

<<<<<<< Updated upstream
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
=======
  Widget buildWelcomeText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strCons.welcome,
          style: context.textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.surface,
            letterSpacing: 0.5,
          ),
        ),
        context.gapSM,
        Text(
          strCons.welcomeText,
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w400,
            color: context.colorScheme.surface.withValues(alpha: 0.8),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget buildEmailField(BuildContext context) {
    return CustomTextInput(
      isModernStyle: true,
      controller: authVM.emailController,
      focusNode: _emailFocusNode,
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      labelText: strCons.email,
      prefixIcon: Icon(
        Icons.email_outlined,
        color: context.colorScheme.surface.withValues(alpha: 0.7),
        size: 20,
      ),
      onFieldSubmitted: (value) {
        // Email'den password'a manuel geçiş
        _passwordFocusNode.requestFocus();
      },
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return CustomTextInput(
          isModernStyle: true,
          controller: authVM.passController,
          focusNode: _passwordFocusNode,
          obscureText: authVM.obscureText,
          textInputAction: TextInputAction.done,
          labelText: strCons.password,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: context.colorScheme.surface.withValues(alpha: 0.7),
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              authVM.togglePasswordVisibility(fieldType: 'main');
            },
            icon: Icon(
              authVM.obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: context.colorScheme.surface.withValues(alpha: 0.7),
              size: 20,
            ),
          ),
          onFieldSubmitted: (value) {
            authVM.controllerCheck(context);
          },
        );
      },
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.tertiary,
            context.colorScheme.tertiaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.tertiary.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
        child: Text(
          strCons.loginText,
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.surface,
            letterSpacing: 0.5,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          child: Text.rich(
            TextSpan(
              text: strCons.dontAccount,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                color: context.colorScheme.onTertiary,
=======
          child: Center(
            child: RichText(
              text: TextSpan(
                text: strCons.dontAccount,
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.surface.withValues(alpha: 0.8),
                ),
                children: [
                  TextSpan(
                    text: " ${strCons.newAccount}",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                ],
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======

  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value * 0.6,
            child: Text(
              "${strCons.companyText}${strCons.splashFooter}",
              style: context.textTheme.labelSmall!.copyWith(
                color: context.colorScheme.surface.withValues(alpha: 0.6),
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
>>>>>>> Stashed changes
}
