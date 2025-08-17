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
import '../core/enums/dialog_type.dart';
import '../core/enums/preferences_keys.dart';
import '../core/enums/sign_status.dart';
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

  void splashCheck(BuildContext context) async {
    bool? isRealDevice = await _deviceService.isRealDevice();

    if (isRealDevice! == false) {
      navigation.navigateToPageClear(path: NavigationConstants.HACK);
    } else {
      if (networkConnectivity.internet) {
        final isAvailableResult = await _authService.isAvalible();
        isAvalibleApp = isAvailableResult;
        if (!context.mounted) return;
        if (isAvailableResult.isSuccess) {
          registerStatus = Platform.isAndroid
              ? isAvailableResult.data?.android?.isRegister
              : isAvailableResult.data?.ios?.isRegister;
          getProfile(context, true);
        } else {
          _showErrorDialog(
            context,
            isAvailableResult.message ?? StringConstants.instance.errorMessage,
          );
        }
      } else {
        // Offline durumda token varsa home'a git
        final token = _storageService.getStringValue(PreferencesKeys.TOKEN);
        if (token.isNotEmpty) {
          navigation.navigateToPageClear(path: NavigationConstants.HOME);
        } else {
          navigation.navigateToPageClear(
            path: NavigationConstants.LOGIN,
            data: registerStatus,
          );
        }
      }
    }
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

      if (!context.mounted) return;
      if (result.isSuccess && result.hasData) {
        await _handleSuccessfulLogin(context, result);
      } else {
        final errorMessage =
            result.message ?? StringConstants.instance.errorMessage;
        _logError('Login Failed', errorMessage);
        _showErrorDialog(context, errorMessage, exitOnClose: false);
      }
    } catch (e, stackTrace) {
      if (!context.mounted) return;
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
    event = SignStatus.logined;
    if (!context.mounted) return;
    await _handleAppVersionCheck(context);
    navigation.navigateToPageClear(path: NavigationConstants.HOME);
    if (!context.mounted) return;
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
      if (!context.mounted) return;
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

  Future getProfile([BuildContext? context, bool? isSplash]) async {
    var utoken = _storageService.getStringValue(PreferencesKeys.TOKEN);

    if (utoken.isNotEmpty) {
      final profileResult = await _authService.profile();
      if (profileResult.isSuccess && profileResult.hasData) {
        user = profileResult.data;
        if (isSplash == null || isSplash == false) {
          Fluttertoast.showToast(
            msg: StringConstants.instance.successMessage,
            backgroundColor: const Color(0xffFF981A),
          );
        }
        await profileSetDataShared(profileResult);
      } else {
        if (isSplash == null || isSplash == false) {
          Fluttertoast.showToast(
            msg: profileResult.message ?? StringConstants.instance.errorMessage,
            backgroundColor: context!.colorScheme.error,
          );
        }
      }
      await profileGetDataShared();
      notifyListeners();
    }
    if (context != null && !context.mounted) return;
    await _handleAppVersionCheck(context);
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
    Timer(const Duration(seconds: 2), () {
      if (user != null) {
        navigation.navigateToPageClear(path: NavigationConstants.HOME);
      } else {
        navigation.navigateToPageClear(
          path: NavigationConstants.LOGIN,
          data: registerStatus,
        );
      }
    });
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
      if (!context.mounted) return;
      if (result is LogoutModelError) {
        _showErrorDialog(context, result.message!, exitOnClose: false);
      } else {
        clearCache();
      }
    } catch (e) {
      _showErrorDialog(
        context,
        "Çıkış işlemi sırasında bir hata oluştu: $e",
        exitOnClose: false,
      );
    }
  }

  void clearCache() async {
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

    // Shift bilgilerini kaydet
    if (user.shift != null) {
      await _storageService.setStringValue(
        PreferencesKeys.SHIFTNAME,
        "Default Shift", // API'de shift name yok, default değer
      );
      await _storageService.setStringValue(
        PreferencesKeys.STARTDATE,
        user.shift!.start ?? "belirtilmedi",
      );
      await _storageService.setStringValue(
        PreferencesKeys.ENDDATE,
        user.shift!.end ?? "belirtilmedi",
      );
      if (user.shift!.tolerance != null) {
        await _storageService.setStringValue(
          PreferencesKeys.STARTTDATE,
          user.shift!.tolerance!.start ?? "00:00",
        );
        await _storageService.setStringValue(
          PreferencesKeys.ENDTDATE,
          user.shift!.tolerance!.end ?? "00:00",
        );
      }
    }
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
    // Zone için default değer - model'de olmadığı için
    await _storageService.setBoolValue(PreferencesKeys.ZONE, false);
  }

  Future<void> setDataShared(BaseModel<List<UserModel>> loginModel) async {
    if (loginModel.data != null &&
        loginModel.data!.isNotEmpty &&
        loginModel.data!.first.accessToken != null) {
      // User değişkenini set et
      user = loginModel.data;

      final userModel = loginModel.data!.first;

      // Token'ı kaydet
      await _storageService.setStringValue(
        PreferencesKeys.TOKEN,
        userModel.accessToken ?? "",
      );

      // Kullanıcı bilgilerini kaydet
      await _storageService.setStringValue(
        PreferencesKeys.USERNAME,
        userModel.name ?? "",
      );
      await _storageService.setStringValue(
        PreferencesKeys.GENDER,
        userModel.gender ?? "",
      );
      await _storageService.setStringValue(
        PreferencesKeys.ID,
        userModel.id?.toString() ?? "",
      );
      await _storageService.setStringValue(
        PreferencesKeys.PHONE,
        userModel.phone ?? "",
      );
      await _storageService.setStringValue(
        PreferencesKeys.EMAIL,
        userModel.email ?? "",
      );
      await _storageService.setStringValue(
        PreferencesKeys.ROLE,
        userModel.role?.name ?? "",
      );

      // Company bilgilerini kaydet
      if (userModel.company != null) {
        await _storageService.setStringValue(
          PreferencesKeys.COMPID,
          userModel.company!.id?.toString() ?? "",
        );
        await _storageService.setStringValue(
          PreferencesKeys.COMPNAME,
          userModel.company!.name ?? "",
        );
        await _storageService.setStringValue(
          PreferencesKeys.COMPADDRESS,
          userModel.company!.address ?? "",
        );
      }

      // Department bilgilerini kaydet
      if (userModel.department != null) {
        await _storageService.setStringValue(
          PreferencesKeys.DEPARTMENTID,
          userModel.department!.id?.toString() ?? "",
        );
        await _storageService.setStringValue(
          PreferencesKeys.DEPARTMENT,
          userModel.department!.name ?? "",
        );
      }

      // Shift bilgilerini kaydet
      if (userModel.shift != null) {
        await _storageService.setStringValue(
          PreferencesKeys.SHIFTNAME,
          "Default Shift",
        );
        await _storageService.setStringValue(
          PreferencesKeys.STARTDATE,
          userModel.shift!.start ?? "belirtilmedi",
        );
        await _storageService.setStringValue(
          PreferencesKeys.ENDDATE,
          userModel.shift!.end ?? "belirtilmedi",
        );

        if (userModel.shift!.tolerance != null) {
          await _storageService.setStringValue(
            PreferencesKeys.STARTTDATE,
            userModel.shift!.tolerance!.start ?? "00:00",
          );
          await _storageService.setStringValue(
            PreferencesKeys.ENDTDATE,
            userModel.shift!.tolerance!.end ?? "00:00",
          );
        }
      }

      // Settings bilgilerini kaydet
      if (userModel.settings != null) {
        await _storageService.setBoolValue(
          PreferencesKeys.OUTSIDE,
          userModel.settings!.outside ?? false,
        );
      }
      await _storageService.setBoolValue(PreferencesKeys.ZONE, false);

      dev.log('Login data saved to storage', name: 'AuthViewModel');

      // Verileri memory'e yükle
      await profileGetDataShared();
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
    startTDate = _storageService.getStringValue(PreferencesKeys.STARTTDATE);
    endTDate = _storageService.getStringValue(PreferencesKeys.ENDTDATE);
    department = _storageService.getStringValue(PreferencesKeys.DEPARTMENT);
    email = _storageService.getStringValue(PreferencesKeys.EMAIL);
    phone = _storageService.getStringValue(PreferencesKeys.PHONE);
    outside = _storageService.getBoolValue(PreferencesKeys.OUTSIDE);
    zone = _storageService.getBoolValue(PreferencesKeys.ZONE);
    notifyListeners();
  }

  _loadUserDataFromStorage() {
    // Önce mevcut durumu koru, gereksiz loading'e set etme
    profileGetDataShared();

    // Token kontrolü daha güvenli hale getir
    final storedToken = _storageService.getStringValue(PreferencesKeys.TOKEN);

    if (storedToken.isNotEmpty) {
      accessToken = storedToken;
      event = SignStatus.logined;
      dev.log(
        'Token loaded from storage, user logged in',
        name: 'AuthViewModel',
      );
    } else {
      accessToken = null;
      event = SignStatus.lyLogin;
      dev.log(
        'No token found in storage, user not logged in',
        name: 'AuthViewModel',
      );
    }

    notifyListeners();
  }
}
