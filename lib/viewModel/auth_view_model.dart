// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../widgets/launch_url.dart';
import '../core/base/view_model/base_view_model.dart';
import '../core/constants/device_constants.dart';
import '../core/constants/navigation_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/network/connectivity/network_connectivity.dart';
import '../core/widget/customize_dialog.dart';
import '../core/widget/loader.dart';

import '../models/base_model.dart';
import '../models/logout_model.dart';
import '../models/user_model.dart';
import '../service/auth_service.dart';
import '../widgets/dialog/snackbar.dart';

enum SignStatus { loading, logined, loginFailed, lyLogin }

bool? registerStatus;

class AuthViewModel extends BaseViewModel {
  final AuthService _authService;
  final DeviceInfoManager _deviceService;
  final NetworkConnectivity networkConnectivity;
  final LocaleManager _storageService;
  static dynamic isAvalibleApp;
  static dynamic user;
  String? version = "1.0.0";
  TextEditingController? emailController;
  TextEditingController? passController;
  TextEditingController? nameController;
  TextEditingController? passConfirmController;
  bool obscureText = true;
  SignStatus event = SignStatus.loading;
  String? accessToken;
  String? userName = "";
  String? gender = "";
  String? role = "";
  String? compName = "";
  String? compAddress = "";
  String? startDate = "";
  String? endDate = "";
  String? startTDate = "";
  String? endTDate = "";
  String? phone = "";
  String? email = "";
  String? shiftName = "";
  String? department = "";
  bool? outside;

  bool? zone;

  AuthViewModel({
    AuthService? authService,
    DeviceInfoManager? deviceService,
    NetworkConnectivity? networkConnectivity,
    LocaleManager? storageService,
  }) : _authService = authService ?? AuthService(),
       _deviceService = deviceService ?? DeviceInfoManager(),
       networkConnectivity = networkConnectivity ?? NetworkConnectivity(),
       _storageService = storageService ?? LocaleManager.instance {
    if (accessToken == null) {
      _loadUserDataFromStorage();
    }
  }

  @override
  void init() {
    _initializeControllers();
    _loadAppVersion();
  }

  void _initializeControllers() {
    emailController = TextEditingController();
    passController = TextEditingController();
    nameController = TextEditingController();
    passConfirmController = TextEditingController();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    notifyListeners();
  }

  @override
  void disp() {
    _disposeControllers();
  }

  void _disposeControllers() {
    emailController?.dispose();
    passController?.dispose();
    nameController?.dispose();
    passConfirmController?.dispose();
  }

  void changeObsure() {
    obscureText = !obscureText;
    notifyListeners();
  }

  /// Centralized error logging
  void _logError(String operation, dynamic error, [StackTrace? stackTrace]) {
    dev.log(
      'AuthViewModel Error in $operation: $error',
      name: 'AuthViewModel',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Safe network connectivity check
  bool _isNetworkConnected() {
    try {
      return networkConnectivity.internet;
    } catch (e) {
      _logError('Network Check', e);
      return false;
    }
  }

  /// Main app initialization with silent login support
  Future<void> initializeApp(BuildContext context) async {
    try {
      // Device validation
      if (!await _isDeviceValid()) {
        _navigateToHackScreen();
        return;
      }

      // Network check and silent login
      await _handleOnlineInitialization(context);
    } catch (e, stackTrace) {
      _logError('App Initialization', e, stackTrace);
      _navigateToLoginScreen();
    }
  }

  Future<void> splashCheck(BuildContext context) async {
    await initializeApp(context);
  }

  Future<void> _handleOnlineInitialization(BuildContext context) async {
    // Check app availability first
    final isAvailableResult = await _authService.isAvalible();
    isAvalibleApp = isAvailableResult;

    if (!isAvailableResult.isSuccess) {
      _showErrorDialog(
        context,
        isAvailableResult.message ?? StringConstants.instance.errorMessage,
      );
      return;
    }

    // Set register status
    registerStatus = Platform.isAndroid
        ? isAvailableResult.data?.android?.isRegister
        : isAvailableResult.data?.ios?.isRegister;

    // Attempt silent login
    await _attemptSilentLogin(context);
  }

  Future<void> _attemptSilentLogin(BuildContext context) async {
    final token = _storageService.getStringValue(PreferencesKeys.TOKEN);

    dev.log(
      'Token read from storage: ${token.isNotEmpty ? "Token found (${token.substring(0, 10)}...)" : "No token found"}',
      name: 'AuthViewModel',
    );

    if (token.isEmpty) {
      dev.log(
        'No stored token found, navigating to login',
        name: 'AuthViewModel',
      );
      await getProfile(context, true);
      return;
    }

    try {
      dev.log(
        'Attempting silent login by fetching profile',
        name: 'AuthViewModel',
      );

      // Direkt profile'i çek - başarılıysa token geçerli demektir
      final profileResult = await _authService.profile();

      if (profileResult.isSuccess && profileResult.hasData) {
        try {
          dev.log(
            'Silent login successful - profile fetched',
            name: 'AuthViewModel',
          );
          user = profileResult.data;
          event = SignStatus.logined;
          await profileSetDataShared(profileResult);
          await _handleAppVersionCheck(context);
          notifyListeners();
          navigation.navigateToPageClear(path: NavigationConstants.HOME);
        } catch (e, stackTrace) {
          _logError('Profile Data Processing', e, stackTrace);
          await _clearInvalidToken();
          await getProfile(context, true);
        }
      } else {
        dev.log(
          'Silent login failed - profile fetch failed: ${profileResult.message}',
          name: 'AuthViewModel',
        );
        await _clearInvalidToken();
        await getProfile(context, true);
      }
    } catch (e, stackTrace) {
      _logError('Silent Login', e, stackTrace);
      await _clearInvalidToken();
      await getProfile(context, true);
    }
  }

  Future<void> _clearInvalidToken() async {
    try {
      await _storageService.clearAll();
      event = SignStatus.lyLogin;
      user = null;
      accessToken = null;
      dev.log('Invalid token cleared', name: 'AuthViewModel');
    } catch (e, stackTrace) {
      _logError('Clear Invalid Token', e, stackTrace);
    }
  }

  void _navigateToLoginScreen() {
    navigation.navigateToPageClear(
      path: NavigationConstants.LOGIN,
      data: registerStatus,
    );
  }

  Future<bool> _isDeviceValid() async {
    return await _deviceService.isRealDevice() ?? false;
  }

  void _navigateToHackScreen() {
    navigation.navigateToPageClear(path: NavigationConstants.HACK);
  }

  void _showErrorDialog(
    BuildContext context,
    String message, {
    bool exitOnClose = true,
  }) {
    CustomizeDialog.show(
      context: context,
      type: DialogType.error,
      message: message,
      exitOnClose: exitOnClose,
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    String message, {
    required Function onConfirm,
  }) {
    CustomizeDialog.show(
      context: context,
      type: DialogType.success,
      message: message,
      onConfirm: onConfirm,
    );
  }

  Future<void> controllerCheck(BuildContext context) async {
    if (!_validateLoginInputs(context)) {
      return;
    }

    Map bodyData = {
      'email': emailController?.text.trim(),
      'password': passController?.text.trim(),
      'device_id': _deviceService.deviceId,
    };

    await _login(context, bodyData);
  }

  bool _validateLoginInputs(BuildContext context) {
    if (_areFieldsEmpty(emailController?.text, passController?.text)) {
      _showErrorDialog(
        context,
        StringConstants.instance.loginErrorMsg,
        exitOnClose: false,
      );
      return false;
    }

    if (emailController!.text.trim().length < 2) {
      _showErrorDialog(
        context,
        StringConstants.instance.loginErrorMsg2,
        exitOnClose: false,
      );
      return false;
    }

    if (!_isEmailValid(emailController!.text)) {
      _showErrorDialog(
        context,
        StringConstants.instance.emailValidMsg,
        exitOnClose: false,
      );
      return false;
    }

    if (!_isPasswordValid(passController!.text)) {
      _showErrorDialog(
        context,
        StringConstants.instance.passwordValidMsg,
        exitOnClose: false,
      );
      return false;
    }

    return true;
  }

  bool _areFieldsEmpty(String? email, String? password) {
    return (email == null ||
        email.trim().isEmpty ||
        password == null ||
        password.trim().isEmpty);
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  bool _isPasswordValid(String password) {
    return RegExp(r'^.{6,}$').hasMatch(password.trim());
  }

  Future<void> _login(BuildContext context, Map bodyData) async {
    Loader.show(context);

    try {
      if (!_isNetworkConnected()) {
        _showErrorDialog(
          context,
          StringConstants.instance.networkMsg,
          exitOnClose: false,
        );
        return;
      }

      final result = await _authService.login(body: bodyData);

      if (result.isSuccess && result.hasData) {
        await _handleSuccessfulLogin(context, result);
      } else {
        final errorMessage =
            result.message ?? StringConstants.instance.errorMessage;
        _logError('Login Failed', errorMessage);
        _showErrorDialog(context, errorMessage, exitOnClose: false);
      }
    } catch (e, stackTrace) {
      _logError('Login Exception', e, stackTrace);
      _showErrorDialog(
        context,
        '${StringConstants.instance.errorMessage} ${StringConstants.instance.errorMessageContinue}',
        exitOnClose: false,
      );
    } finally {
      Loader.hide();
    }
  }

  Future<void> _handleSuccessfulLogin(
    BuildContext context,
    BaseModel<List<UserModel>> data,
  ) async {
    await setDataShared(data);
    event = SignStatus.logined; // Event'i önce set et

    // Login başarılı olduktan sonra profile bilgileri zaten data'da mevcut
    // Tekrar API çağrısı yapmaya gerek yok
    await _handleAppVersionCheck(context);

    navigation.navigateToPageClear(path: NavigationConstants.HOME);
    CustomSnackBar(context, StringConstants.instance.loginSuccessMsg);
  }

  Future<void> registerInputCheck(BuildContext context) async {
    if (!_validateRegisterInputs(context)) {
      return;
    }

    Map dataRegister = {
      'name': nameController?.text.trim(),
      'email': emailController?.text.trim(),
      'password': passController?.text.trim(),
      'password_confirm': passConfirmController?.text.trim(),
    };

    await _register(context, dataRegister);
  }

  bool _validateRegisterInputs(BuildContext context) {
    if (_areRegisterFieldsEmpty()) {
      _showErrorDialog(
        context,
        StringConstants.instance.notEmptyText,
        exitOnClose: false,
      );
      return false;
    }

    if (nameController!.text.trim().length < 5) {
      _showErrorDialog(
        context,
        StringConstants.instance.registerNameErrorMsg,
        exitOnClose: false,
      );
      return false;
    }

    if (!_isEmailValid(emailController!.text)) {
      _showErrorDialog(
        context,
        StringConstants.instance.emailValidMsg,
        exitOnClose: false,
      );
      return false;
    }

    if (!_isPasswordValid(passController!.text)) {
      _showErrorDialog(
        context,
        StringConstants.instance.passwordValidMsg,
        exitOnClose: false,
      );
      return false;
    }

    return true;
  }

  bool _areRegisterFieldsEmpty() {
    return nameController!.text.trim().isEmpty ||
        emailController!.text.trim().isEmpty ||
        passController!.text.trim().isEmpty ||
        passConfirmController!.text.trim().isEmpty;
  }

  Future<void> _register(BuildContext context, Map dataRegister) async {
    Loader.show(context);

    try {
      if (!_isNetworkConnected()) {
        _showErrorDialog(
          context,
          StringConstants.instance.networkMsg,
          exitOnClose: false,
        );
        return;
      }

      final result = await _authService.register(body: dataRegister);

      if (result.isSuccess) {
        final message =
            result.message ?? StringConstants.instance.successMessage;
        _showSuccessDialog(
          context,
          message,
          onConfirm: () => _navigateToLoginAfterRegistration(),
        );
      } else {
        final errorMessage =
            result.message ?? StringConstants.instance.errorMessage;
        _logError('Registration Failed', errorMessage);
        _showErrorDialog(context, errorMessage, exitOnClose: false);
      }
    } catch (e, stackTrace) {
      _logError('Registration Exception', e, stackTrace);
      _showErrorDialog(
        context,
        '${StringConstants.instance.errorMessage} ${StringConstants.instance.errorMessageContinue}',
        exitOnClose: false,
      );
    } finally {
      Loader.hide();
    }
  }

  void _navigateToLoginAfterRegistration() {
    navigation.navigateToPageClear(
      path: NavigationConstants.LOGIN,
      data: registerStatus,
    );
  }

  Future<void> getProfile([BuildContext? context, bool? isSplash]) async {
    try {
      await _fetchUserProfile(context, isSplash);
      await _handleAppVersionCheck(context);
    } catch (e, stackTrace) {
      _logError('Get Profile', e, stackTrace);

      // Sadece splash sırasında login'e dön, normal login sonrası hata durumunda dönme
      if (isSplash == true) {
        _navigateToLoginScreen();
      } else if (context != null) {
        _showErrorDialog(
          context,
          StringConstants.instance.errorMessage,
          exitOnClose: false,
        );
      }
    }
  }

  Future<void> _fetchUserProfile(BuildContext? context, bool? isSplash) async {
    final token = _storageService.getStringValue(PreferencesKeys.TOKEN);

    if (token.isEmpty) {
      _logError('Profile Fetch', 'No token available');
      return;
    }

    try {
      final profileResult = await _authService.profile();

      if (profileResult.isSuccess && profileResult.hasData) {
        user = profileResult.data;
        await profileSetDataShared(profileResult);

        if (isSplash != true && context != null) {
          Fluttertoast.showToast(
            msg: StringConstants.instance.successMessage,
            backgroundColor: const Color(0xffFF981A),
          );
        }
      } else {
        final errorMessage =
            profileResult.message ?? StringConstants.instance.errorMessage;
        _logError('Profile Fetch Failed', errorMessage);

        if (isSplash != true && context != null) {
          Fluttertoast.showToast(
            msg: errorMessage,
            backgroundColor: context.colorScheme.error,
          );
        }
      }

      await profileGetDataShared();
      notifyListeners();
    } catch (e, stackTrace) {
      _logError('Profile Fetch Exception', e, stackTrace);
      // Hata durumunda rethrow yapmayalım, sadece log edelim
      // rethrow;
    }
  }

  Future<void> _handleAppVersionCheck(BuildContext? context) async {
    if (isAvalibleApp == null) {
      _navigateBasedOnUserStatus();
      return;
    }

    try {
      final currentVersion = int.parse(version?.replaceAll(".", "") ?? "0");

      if (Platform.isAndroid) {
        await _handleAndroidVersionCheck(context, currentVersion);
      } else if (Platform.isIOS) {
        await _handleIOSVersionCheck(context, currentVersion);
      }
    } catch (e, stackTrace) {
      _logError('Version Check', e, stackTrace);
      _navigateBasedOnUserStatus();
    }
  }

  Future<void> _handleAndroidVersionCheck(
    BuildContext? context,
    int currentVersion,
  ) async {
    final androidVersion = isAvalibleApp?.data?.android?.version ?? 0;

    if (androidVersion > currentVersion) {
      _showUpdateDialog(context, isAvalibleApp.data.android!.link);
    } else {
      Timer(const Duration(seconds: 2), _navigateBasedOnUserStatus);
    }
  }

  Future<void> _handleIOSVersionCheck(
    BuildContext? context,
    int currentVersion,
  ) async {
    final iosVersion = isAvalibleApp?.data?.ios?.version ?? 0;

    if (iosVersion > currentVersion) {
      _showUpdateDialog(context, isAvalibleApp.data.ios!.link);
    } else {
      Timer(const Duration(seconds: 3), _navigateBasedOnUserStatus);
    }
  }

  void _showUpdateDialog(BuildContext? context, String updateUrl) {
    if (context == null) return;

    CustomizeDialog.show(
      context: context,
      type: DialogType.update,
      message: StringConstants.instance.appMessage,
      onConfirm: () => UrlLaunch.openUrl(context, updateUrl),
    );
  }

  void _navigateBasedOnUserStatus() {
    // Login başarılı olduysa user set edilmiş olmalı
    final targetPath = user != null && event == SignStatus.logined
        ? NavigationConstants.HOME
        : NavigationConstants.LOGIN;

    navigation.navigateToPageClear(
      path: targetPath,
      data: user == null ? registerStatus : null,
    );
  }

  Future<void> fetchLogout(BuildContext context) async {
    String token = _storageService.getStringValue(PreferencesKeys.TOKEN);

    if (!_isNetworkConnected()) {
      _showErrorDialog(
        context,
        StringConstants.instance.networkMsg,
        exitOnClose: false,
      );
      return;
    }

    try {
      var result = await _authService.logout(token);

      if (result is LogoutModelError) {
        _showErrorDialog(context, result.message!, exitOnClose: false);
      } else {
        await _clearCache();
      }
    } catch (e) {
      _showErrorDialog(
        context,
        "Çıkış işlemi sırasında bir hata oluştu: $e",
        exitOnClose: false,
      );
    }
  }

  Future<void> _clearCache() async {
    await _storageService.clearAll();
    navigation.navigateToPageClear(path: NavigationConstants.LOGIN);
  }

  Future<void> profileSetDataShared(
    BaseModel<List<UserModel>> profileModel,
  ) async {
    await _storeUserData(profileModel.data);

    // Company data varsa kaydet
    if (profileModel.data!.first.company != null) {
      await _storeCompanyData(profileModel.data!.first.company);
    }

    // Department data varsa kaydet
    if (profileModel.data!.first.department != null) {
      await _storeDepartmentData(profileModel.data!.first.department);
    }

    // Settings data varsa kaydet
    if (profileModel.data!.first.settings != null) {
      await _storeSettingsData(profileModel.data!.first.settings);
    }

    await profileGetDataShared();
  }

  Future<void> _storeUserData(dynamic userData) async {
    // userData bir List<UserModel>, ilk elemanını al
    final user = userData is List ? userData.first : userData;

    // UserModel'deki field'lara göre kaydet
    await _storageService.setStringValue(
      PreferencesKeys.ID,
      user.id?.toString() ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.USERNAME,
      user.name ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.GENDER,
      user.gender ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.PHONE,
      user.phone ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.EMAIL,
      user.email ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.ROLE,
      user.role?.name ?? "",
    );
    // TITLE field'ı UserModel'de yok, boş bırak veya kaldır
    // await _storageService.setStringValue(PreferencesKeys.TITLE, "");
  }

  Future<void> _storeCompanyData(dynamic companyData) async {
    if (companyData == null) return;

    await _storageService.setStringValue(
      PreferencesKeys.COMPID,
      companyData.id?.toString() ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.COMPNAME,
      companyData.name ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.COMPADDRESS,
      companyData.address ?? "",
    );
  }

  Future<void> _storeDepartmentData(dynamic departmentData) async {
    if (departmentData == null) return;

    await _storageService.setStringValue(
      PreferencesKeys.DEPARTMENTID,
      departmentData.id?.toString() ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.DEPARTMENT,
      departmentData.name ?? "",
    );
  }

  Future<void> _storeSettingsData(dynamic settingsData) async {
    if (settingsData == null) return;

    await _storageService.setBoolValue(
      PreferencesKeys.OUTSIDE,
      settingsData.outside ?? false,
    );
    await _storageService.setBoolValue(
      PreferencesKeys.ZONE,
      settingsData.zone ?? false,
    );
  }

  Future<void> setDataShared(BaseModel<List<UserModel>> loginModel) async {
    if (loginModel.data != null &&
        loginModel.data!.isNotEmpty &&
        loginModel.data!.first.accessToken != null) {
      // User değişkenini set et
      user = loginModel.data;

      final tokenToSave = loginModel.data!.first.accessToken ?? "";
      await _storageService.setStringValue(PreferencesKeys.TOKEN, tokenToSave);

      dev.log(
        'Token saved to storage: ${tokenToSave.isNotEmpty ? "Token saved (${tokenToSave.substring(0, 10)}...)" : "Empty token saved"}',
        name: 'AuthViewModel',
      );
      await _loadUserDataFromStorage();
    }
  }

  Future<void> profileGetDataShared() async {
    userName = _storageService.getStringValue(PreferencesKeys.USERNAME);
    gender = _storageService.getStringValue(PreferencesKeys.GENDER);
    accessToken = _storageService.getStringValue(PreferencesKeys.TOKEN);
    shiftName = _storageService.getStringValue(PreferencesKeys.SHIFTNAME);
    role = _storageService.getStringValue(PreferencesKeys.ROLE);
    compName = _storageService.getStringValue(PreferencesKeys.COMPNAME);
    compAddress = _storageService.getStringValue(PreferencesKeys.COMPADDRESS);
    startDate = _storageService.getStringValue(PreferencesKeys.STARTDATE);
    endDate = _storageService.getStringValue(PreferencesKeys.ENDDATE);
    startTDate = _storageService.getStringValue(PreferencesKeys.STARTDATE);
    endTDate = _storageService.getStringValue(PreferencesKeys.ENDTDATE);
    department = _storageService.getStringValue(PreferencesKeys.DEPARTMENT);
    email = _storageService.getStringValue(PreferencesKeys.EMAIL);
    phone = _storageService.getStringValue(PreferencesKeys.PHONE);
    outside = _storageService.getBoolValue(PreferencesKeys.OUTSIDE);

    zone = _storageService.getBoolValue(PreferencesKeys.ZONE);
    notifyListeners();
  }

  _loadUserDataFromStorage() {
    event = SignStatus.loading;
    profileGetDataShared();

    if (accessToken != null && accessToken!.isNotEmpty) {
      event = SignStatus.logined;
    } else {
      event = SignStatus.lyLogin;
    }
  }
}
