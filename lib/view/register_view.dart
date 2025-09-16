import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/constants/navigation_constants.dart';
import '../core/utils/phone_formatter.dart';
import '../viewModel/auth_view_model.dart';
import '../widgets/text_input/custom_text_input.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with BaseSingleton, SizeSingleton, TickerProviderStateMixin {
  late AuthViewModel authVM;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late FocusNode _nameFocusNode;
  late FocusNode _surnameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _phoneFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _passwordConfirmFocusNode;

  @override
  void initState() {
    super.initState();
    authVM = Provider.of<AuthViewModel>(context, listen: false);
    authVM.init();
    _nameFocusNode = FocusNode();
    _surnameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfirmFocusNode = FocusNode();
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
    _nameFocusNode.dispose();
    _surnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    physics: const ClampingScrollPhysics(),
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
                            Expanded(child: buildRegisterCard(context)),
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

  Widget buildRegisterCard(BuildContext context) {
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
                  padding: const EdgeInsets.all(24),
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildWelcomeText(context),
                        const SizedBox(height: 20),
                        buildNameField(context),
                        const SizedBox(height: 16),
                        buildSurnameField(context),
                        const SizedBox(height: 16),
                        buildEmailField(context),
                        const SizedBox(height: 16),
                        buildPhoneField(context),
                        const SizedBox(height: 16),
                        buildPasswordField(context),
                        const SizedBox(height: 16),
                        buildPasswordConfirmField(context),
                        const SizedBox(height: 32),
                        buildRegisterButton(context),
                        buildLoginText(context),
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
          strCons.signUp,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          strCons.signUpText,
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

  Widget buildNameField(BuildContext context) {
    return CustomTextInput(
      isModernStyle: true,
      controller: authVM.nameController,
      focusNode: _nameFocusNode,
      textInputType: TextInputType.name,
      textInputAction: TextInputAction.next,
      labelText: strCons.name,
      prefixIcon: Icon(
        Icons.person_outlined,
        color: Colors.white.withValues(alpha: 0.7),
        size: 20,
      ),
      onFieldSubmitted: (value) {
        _surnameFocusNode.requestFocus();
      },
    );
  }

  Widget buildSurnameField(BuildContext context) {
    return CustomTextInput(
      isModernStyle: true,
      controller: authVM.surnameController,
      focusNode: _surnameFocusNode,
      textInputType: TextInputType.name,
      textInputAction: TextInputAction.next,
      labelText: strCons.surname,
      prefixIcon: Icon(
        Icons.badge_outlined,
        color: Colors.white.withValues(alpha: 0.7),
        size: 20,
      ),
      onFieldSubmitted: (value) {
        _emailFocusNode.requestFocus();
      },
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
        _phoneFocusNode.requestFocus();
      },
    );
  }

  Widget buildPhoneField(BuildContext context) {
    return CustomTextInput(
      isModernStyle: true,
      controller: authVM.phoneController,
      focusNode: _phoneFocusNode,
      textInputType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      labelText: strCons.phone,
      hintText: "0(5xx)xxx xx xx",
      inputFormatters: [PhoneFormatter()],
      prefixIcon: Icon(
        Icons.phone_outlined,
        color: Colors.white.withValues(alpha: 0.7),
        size: 20,
      ),
      onFieldSubmitted: (value) {
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
          obscureText: authVM.registerObscureText,
          textInputAction: TextInputAction.next,
          labelText: strCons.password,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: Colors.white.withValues(alpha: 0.7),
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              authVM.togglePasswordVisibility(fieldType: 'register');
            },
            icon: Icon(
              authVM.registerObscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.white.withValues(alpha: 0.7),
              size: 20,
            ),
          ),
          onFieldSubmitted: (value) {
            _passwordConfirmFocusNode.requestFocus();
          },
        );
      },
    );
  }

  Widget buildPasswordConfirmField(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return CustomTextInput(
          isModernStyle: true,
          controller: authVM.passConfirmController,
          focusNode: _passwordConfirmFocusNode,
          obscureText: authVM.registerConfirmObscureText,
          textInputAction: TextInputAction.done,
          labelText: strCons.passwordConfirm,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: Colors.white.withValues(alpha: 0.7),
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              authVM.togglePasswordVisibility(fieldType: 'registerConfirm');
            },
            icon: Icon(
              authVM.registerConfirmObscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.white.withValues(alpha: 0.7),
              size: 20,
            ),
          ),
          onFieldSubmitted: (value) {
            authVM.registerInputCheck(context);
          },
        );
      },
    );
  }

  Widget buildRegisterButton(BuildContext context) {
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
          authVM.registerInputCheck(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          strCons.signUp,
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

  Widget buildLoginText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: GestureDetector(
        onTap: () {
          authVM.navigation.navigateToPageClear(
            path: NavigationConstants.LOGIN,
          );
        },
        child: Center(
          child: RichText(
            text: TextSpan(
              text: "Zaten hesabınız var mı?",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              children: [
                TextSpan(
                  text: " Giriş Yapın",
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
