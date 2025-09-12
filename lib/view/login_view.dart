import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/constants/navigation_constants.dart';
import '../viewModel/auth_view_model.dart';
import '../widgets/text_input/custom_text_input.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with BaseSingleton, SizeSingleton, TickerProviderStateMixin {
  late AuthViewModel authVM;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    authVM = Provider.of<AuthViewModel>(context, listen: false);
    authVM.init();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
    authVM.disp();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
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
                  const Color(0xFF1E3A8A),
                  const Color(0xFF3B82F6),
                  const Color(0xFF1E40AF),
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
                        Colors.white,
                        const Color(0xFFF97316),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      strCons.appName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${strCons.splashText1} ${strCons.splashText2}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ] else ...[
                  Text(
                    strCons.appName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildLoginCard(BuildContext context, args) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            constraints: const BoxConstraints(maxWidth: 400),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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
                        const SizedBox(height: 24),
                        buildEmailField(context),
                        const SizedBox(height: 20),
                        buildPasswordField(context),
                        const SizedBox(height: 32),
                        buildLoginButton(context),
                        buildRegisterText(context, args),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildWelcomeText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strCons.welcome,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          strCons.welcomeText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.8),
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
        color: Colors.white.withValues(alpha: 0.7),
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
            color: Colors.white.withValues(alpha: 0.7),
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
              color: Colors.white.withValues(alpha: 0.7),
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
          colors: [const Color(0xFFF97316), const Color(0xFFEA580C)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF97316).withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          authVM.controllerCheck(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          strCons.loginText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget buildRegisterText(BuildContext context, args) {
    return Visibility(
      visible: args ?? false,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: GestureDetector(
          onTap: () {
            authVM.navigation.navigateToPage(
              path: NavigationConstants.REGISTER,
            );
          },
          child: Center(
            child: RichText(
              text: TextSpan(
                text: strCons.dontAccount,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                children: [
                  TextSpan(
                    text: " ${strCons.newAccount}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF97316),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.6),
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
