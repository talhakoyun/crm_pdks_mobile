// ignore_for_file: use_build_context_synchronously

import 'dart:async';
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
import '../helper/database_helper.dart';
import '../models/base_model.dart';
import '../models/is_available_model.dart';
import '../models/logout_model.dart';
import '../models/register_model.dart';
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
  String? title = "";
  String? shiftName = "";
  String? department = "";
  bool? outside;
  bool? offline;
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

  Future<void> splashCheck(BuildContext context) async {
    if (!await _isDeviceValid()) {
      _navigateToHackScreen();
      return;
    }

    if (_isNetworkConnected()) {
      await _handleOnlineMode(context);
    } else {
      _handleOfflineMode(context);
    }
  }

  Future<bool> _isDeviceValid() async {
    return await _deviceService.isRealDevice() ?? false;
  }

  void _navigateToHackScreen() {
    navigation.navigateToPageClear(path: NavigationConstants.HACK);
  }

  bool _isNetworkConnected() {
    return networkConnectivity.internet;
  }

  Future<void> _handleOnlineMode(BuildContext context) async {
    IsAvailableModel? isAvailableModel = await _authService.isAvalible();
    isAvalibleApp = isAvailableModel;

    if (isAvailableModel.status == true) {
      _processSuccessfulAvailabilityCheck(isAvailableModel, context);
    } else if (isAvailableModel.status == false) {
      _showErrorDialog(context, isAvailableModel.message!);
    } else {
      _showErrorDialog(
        context,
        StringConstants.instance.errorMessage +
            StringConstants.instance.errorMessageContinue,
      );
    }
  }

  void _processSuccessfulAvailabilityCheck(
    IsAvailableModel model,
    BuildContext context,
  ) {
    registerStatus = Platform.isAndroid
        ? model.data!.android!.isRegister
        : model.data!.ios!.isRegister;
    getProfile(context, true);
  }

  void _handleOfflineMode(BuildContext context) {
    bool? offlineSplash = _storageService.getBoolValue(PreferencesKeys.OFFLINE);
    String? accessToken = _storageService.getStringValue(PreferencesKeys.TOKEN);

    if (offlineSplash && accessToken.isNotEmpty) {
      navigation.navigateToPageClear(path: NavigationConstants.HOME);
    } else {
      navigation.navigateToPageClear(
        path: NavigationConstants.LOGIN,
        data: registerStatus,
      );
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

    if (!_isNetworkConnected()) {
      Loader.hide();
      _showErrorDialog(
        context,
        StringConstants.instance.networkMsg,
        exitOnClose: false,
      );
      return;
    }

    try {
      BaseModel<List<UserModel>> data = await _authService.login(
        body: bodyData,
      );
      Loader.hide();

      if (data.status!) {
        _handleSuccessfulLogin(context, data);
      } else {
        _showErrorDialog(context, data.message ?? "", exitOnClose: false);
      }
    } catch (e) {
      Loader.hide();
      _showErrorDialog(
        context,
        StringConstants.instance.errorMessage +
            StringConstants.instance.errorMessageContinue,
        exitOnClose: false,
      );
    }
  }

  Future<void> _handleSuccessfulLogin(
    BuildContext context,
    BaseModel<List<UserModel>> data,
  ) async {
    await setDataShared(data);
    await getProfile(context, false);
    event = SignStatus.logined;
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

    if (!_isNetworkConnected()) {
      Loader.hide();
      _showErrorDialog(
        context,
        StringConstants.instance.networkMsg,
        exitOnClose: false,
      );
      return;
    }

    try {
      RegisterModel data = await _authService.register(body: dataRegister);
      Loader.hide();

      if (data.status!) {
        _showSuccessDialog(
          context,
          data.message!,
          onConfirm: () => _navigateToLoginAfterRegistration(),
        );
      } else {
        _showErrorDialog(context, data.message!, exitOnClose: false);
      }
    } catch (e) {
      Loader.hide();
      _showErrorDialog(
        context,
        StringConstants.instance.errorMessage +
            StringConstants.instance.errorMessageContinue,
        exitOnClose: false,
      );
    }
  }

  void _navigateToLoginAfterRegistration() {
    navigation.navigateToPageClear(
      path: NavigationConstants.LOGIN,
      data: registerStatus,
    );
  }

  Future<void> getProfile([BuildContext? context, bool? isSplash]) async {
    var utoken = _storageService.getStringValue(PreferencesKeys.TOKEN);

    if (utoken.isNotEmpty) {
      BaseModel<List<UserModel>> profileModel = await _authService.profile();

      if (profileModel.status == true) {
        user = profileModel.data;

        if (isSplash == null || isSplash == false) {
          Fluttertoast.showToast(
            msg: StringConstants.instance.successMessage,
            backgroundColor: const Color(0xffFF981A),
          );
        }

        await profileSetDataShared(profileModel);
      } else {
        if (isSplash == null || isSplash == false) {
          Fluttertoast.showToast(
            msg: profileModel.message!,
            backgroundColor: context!.colorScheme.error,
          );
        }
      }

      await Future.delayed(Duration.zero);
      await profileGetDataShared();
      notifyListeners();
    }

    if (isAvalibleApp != null) {
      if (Platform.isAndroid) {
        if (isAvalibleApp.data.android!.version >
            int.parse(version!.replaceAll(".", ""))) {
          CustomizeDialog.show(
            context: context!,
            type: DialogType.update,
            message: StringConstants.instance.appMessage,
            onConfirm: () =>
                UrlLaunch.openUrl(context, isAvalibleApp.data.android!.link),
          );
        } else {
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
      }

      if (Platform.isIOS) {
        if (isAvalibleApp.data.ios!.version >
            int.parse(version!.replaceAll(".", ""))) {
          CustomizeDialog.show(
            context: context!,
            type: DialogType.update,
            message: StringConstants.instance.appMessage,
            onConfirm: () =>
                UrlLaunch.openUrl(context, isAvalibleApp.data.ios!.link),
          );
        } else {
          Timer(const Duration(seconds: 3), () {
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
      }
    } else {
      navigation.navigateToPageClear(
        path: NavigationConstants.LOGIN,
        data: registerStatus,
      );
    }
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
    await DatabaseHelper.instance.deleteMyDatabase();
    await _storageService.clearAll();
    navigation.navigateToPageClear(path: NavigationConstants.LOGIN);
  }

  Future<void> profileSetDataShared(
    BaseModel<List<UserModel>> profileModel,
  ) async {
    await _storeUserData(profileModel.data);
    await _storeCompanyData(profileModel.data!.first.company);
    await _storeDepartmentData(profileModel.data!.first.department);
    // await _storeShiftData(profileModel.data!.first.shiftTime);
    await _storeSettingsData(profileModel.data!.first.settings);
    await profileGetDataShared();
  }

  Future<void> _storeUserData(dynamic userData) async {
    await _storageService.setStringValue(
      PreferencesKeys.USERNAME,
      userData!.name ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.GENDER,
      userData.gender ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.ID,
      userData.id.toString(),
    );
    await _storageService.setStringValue(
      PreferencesKeys.PHONE,
      userData.phone ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.EMAIL,
      userData.email ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.ROLE,
      userData.role ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.TITLE,
      userData.title ?? "",
    );
  }

  Future<void> _storeCompanyData(dynamic companyData) async {
    await _storageService.setStringValue(
      PreferencesKeys.COMPID,
      companyData!.id.toString(),
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
    await _storageService.setStringValue(
      PreferencesKeys.DEPARTMENTID,
      departmentData!.id.toString(),
    );
    await _storageService.setStringValue(
      PreferencesKeys.DEPARTMENT,
      departmentData.name ?? "",
    );
  }

  Future<void> _storeSettingsData(dynamic settingsData) async {
    await _storageService.setBoolValue(
      PreferencesKeys.OFFLINE,
      settingsData!.offline ?? false,
    );
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
      await _storageService.setStringValue(
        PreferencesKeys.TOKEN,
        loginModel.data!.first.accessToken ?? "",
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
    title = _storageService.getStringValue(PreferencesKeys.TITLE);
    phone = _storageService.getStringValue(PreferencesKeys.PHONE);
    outside = _storageService.getBoolValue(PreferencesKeys.OUTSIDE);
    offline = _storageService.getBoolValue(PreferencesKeys.OFFLINE);
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
