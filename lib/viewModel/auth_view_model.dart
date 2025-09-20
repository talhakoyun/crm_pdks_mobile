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
import '../core/constants/service_locator.dart';
import '../core/enums/dialog_type.dart';
import '../core/enums/preferences_keys.dart';
import '../core/enums/sign_status.dart';
import '../core/extension/context_extension.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/network/connectivity/network_connectivity.dart';
import '../core/init/network/exception/app_exception.dart';
import '../core/widget/dialog/dialog_factory.dart';
import '../core/widget/loader.dart';
import '../models/base_model.dart';
import '../models/logout_model.dart';
import '../models/user_model.dart';
import '../models/user_data.dart';
import '../repository/user_data_repository.dart';
import '../service/auth_service.dart';
import '../widgets/snackbar.dart';

bool? registerStatus;

class AuthViewModel extends BaseViewModel {
  final AuthService _authService;
  final DeviceInfoManager _deviceService;
  final NetworkConnectivity networkConnectivity;
  final LocaleManager _storageService;
  final UserDataRepository _userDataRepository;
  dynamic isAvalibleApp;
  UserData? user;
  String? version = "1.0.0";
  TextEditingController? emailController;
  TextEditingController? passController;
  TextEditingController? nameController;
  TextEditingController? surnameController;
  TextEditingController? phoneController;
  TextEditingController? passConfirmController;
  bool obscureText = true;
  bool currentObscureText = true;
  bool newObscureText = true;
  bool newConfirmObscureText = true;
  bool registerObscureText = true;
  bool registerConfirmObscureText = true;
  SignStatus event = SignStatus.loading;
  String? get userName => user?.username;
  String? get gender => user?.gender;
  String? get role => user?.role;
  String? get compName => user?.companyName;
  String? get compAddress => user?.companyAddress;
  String? get startDate => user?.startDate;
  String? get endDate => user?.endDate;
  String? get startTDate => user?.startTDate;
  String? get endTDate => user?.endTDate;
  String? get department => user?.department;
  String? get phone => user?.phone;
  String? get email => user?.email;
  bool? get outside => user?.outside;

  String? _accessToken;
  String? get accessToken => _accessToken;
  set accessToken(String? value) {
    _accessToken = value;
    notifyListeners();
  }

  AuthViewModel({
    AuthService? authService,
    DeviceInfoManager? deviceService,
    NetworkConnectivity? networkConnectivity,
    LocaleManager? storageService,
  }) : _authService = authService ?? ServiceLocator.instance.get<AuthService>(),
       _deviceService =
           deviceService ?? ServiceLocator.instance.get<DeviceInfoManager>(),
       networkConnectivity =
           networkConnectivity ??
           ServiceLocator.instance.get<NetworkConnectivity>(),
       _storageService =
           storageService ?? ServiceLocator.instance.get<LocaleManager>(),
       _userDataRepository = UserDataRepository(
         storageService ?? ServiceLocator.instance.get<LocaleManager>(),
       ),
       super(localeManager: storageService, navigationService: null) {
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
    emailController = _initializeSafeController(emailController);
    passController = _initializeSafeController(passController);
    nameController = _initializeSafeController(nameController);
    surnameController = _initializeSafeController(surnameController);
    phoneController = _initializeSafeController(phoneController);
    passConfirmController = _initializeSafeController(passConfirmController);
  }

  TextEditingController _initializeSafeController(
    TextEditingController? controller,
  ) {
    if (controller == null) {
      return TextEditingController();
    }

    try {
      controller.text;
      return controller;
    } catch (e) {
      return TextEditingController();
    }
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    notifyListeners();
  }

  @override
  void disp() {
    _clearControllers();
  }

  void _clearControllers() {
    final controllers = [
      emailController,
      passController,
      nameController,
      surnameController,
      phoneController,
      passConfirmController,
    ];

    for (final controller in controllers) {
      try {
        controller?.clear();
      } catch (e) {
        debugPrint('Controller clear hatası: $e');
      }
    }
  }

  void forceDispose() {
    _disposeControllers();
  }

  void _disposeControllers() {
    final controllersWithSetters = [
      (emailController, (TextEditingController? c) => emailController = c),
      (passController, (TextEditingController? c) => passController = c),
      (nameController, (TextEditingController? c) => nameController = c),
      (surnameController, (TextEditingController? c) => surnameController = c),
      (phoneController, (TextEditingController? c) => phoneController = c),
      (
        passConfirmController,
        (TextEditingController? c) => passConfirmController = c,
      ),
    ];

    for (final (controller, setter) in controllersWithSetters) {
      try {
        controller?.dispose();
        setter(null);
      } catch (e) {
        debugPrint('Controller dispose hatası: $e');
      }
    }
  }

  void togglePasswordVisibility({String? fieldType}) {
    switch (fieldType) {
      case 'main':
        obscureText = !obscureText;
        break;
      case 'current':
        currentObscureText = !currentObscureText;
        break;
      case 'new':
        newObscureText = !newObscureText;
        break;
      case 'newConfirm':
        newConfirmObscureText = !newConfirmObscureText;
      case 'register':
        registerObscureText = !registerObscureText;
        break;
      case 'registerConfirm':
        registerConfirmObscureText = !registerConfirmObscureText;
        break;
    }
    notifyListeners();
  }

  bool _isNetworkConnected() {
    try {
      return networkConnectivity.internet;
    } catch (e) {
      return false;
    }
  }

  void splashCheck(BuildContext context) async {
    bool? isRealDevice = await _deviceService.isRealDevice();

    if (isRealDevice! != false) {
      navigation.navigateToPageClear(path: NavigationConstants.HACK);
    } else {
      if (networkConnectivity.internet) {
        final isAvailableResult = await _authService.isAvalible();
        isAvalibleApp = isAvailableResult;
        if (!context.mounted) {
          return;
        }

        if (isAvailableResult.isSuccess) {
          registerStatus = Platform.isAndroid
              ? isAvailableResult.data?.android?.isRegister
              : isAvailableResult.data?.ios?.isRegister;
          getProfile(context, true);
        } else {
          final token = _storageService.getStringValue(PreferencesKeys.TOKEN);
          if (token.isNotEmpty) {
            _navigateBasedOnUserStatus();
          } else {
            _showErrorDialog(
              context,
              isAvailableResult.message ??
                  StringConstants.instance.errorMessage,
            );
          }
        }
      } else {
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
    DialogFactory.create(
      context: context,
      type: DialogType.error,
      parameters: {'message': message, 'exitOnClose': exitOnClose},
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    String message, {
    required Function onConfirm,
  }) {
    DialogFactory.create(
      context: context,
      type: DialogType.success,
      parameters: {'message': message, 'onConfirm': onConfirm},
    );
  }

  Future<void> controllerCheck(BuildContext context) async {
    if (!_validateLoginInputs(context)) {
      return;
    }

    String deviceId;
    try {
      deviceId = await _deviceService.getDeviceIdSafe();
    } catch (e) {
      deviceId = 'unknown_device';
    }

    Map bodyData = {
      'email': emailController?.text.trim(),
      'password': passController?.text.trim(),
      'device_id': deviceId,
    };
    if (!context.mounted) return;
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
        _showErrorDialog(context, errorMessage, exitOnClose: false);
      }
    } on AppException catch (e) {
      if (!context.mounted) return;
      String errorMessage = e.msg ?? StringConstants.instance.errorMessage;
      _showErrorDialog(context, errorMessage, exitOnClose: false);
    } catch (e) {
      if (!context.mounted) return;
      String errorMessage = StringConstants.instance.errorMessage;
      if (e is String) {
        errorMessage = e;
      } else if (e is Exception) {
        errorMessage = e.toString();
      } else if (e is Map && e.containsKey('message')) {
        errorMessage = e['message'].toString();
      } else if (e is Map<String, dynamic> && e.containsKey('message')) {
        errorMessage = e['message'].toString();
      }
      _showErrorDialog(context, errorMessage, exitOnClose: false);
    } finally {
      Loader.hide();
    }
  }

  Future<void> _handleSuccessfulLogin(
    BuildContext context,
    BaseModel<List<UserModel>> data,
  ) async {
    await _saveUserDataFromModel(data);
    event = SignStatus.logined;
    if (!context.mounted) return;
    CustomSnackBar(context, StringConstants.instance.loginSuccessMsg);
    navigation.navigateToPageClear(path: NavigationConstants.HOME);
  }

  Future<void> registerInputCheck(BuildContext context) async {
    if (!_validateRegisterInputs(context)) {
      return;
    }

    Map dataRegister = {
      'name': nameController?.text.trim(),
      'surname': surnameController?.text.trim(),
      'email': emailController?.text.trim(),
      'phone': phoneController?.text.trim(),
      'password': passController?.text.trim(),
      'password_confirmation': passConfirmController?.text.trim(),
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

    if (nameController!.text.trim().length < 2) {
      _showErrorDialog(
        context,
        StringConstants.instance.registerNameErrorMsg,
        exitOnClose: false,
      );
      return false;
    }

    if (surnameController!.text.trim().length < 2) {
      _showErrorDialog(
        context,
        StringConstants.instance.registerSurnameErrorMsg,
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

    if (phoneController!.text.trim().length < 15) {
      _showErrorDialog(
        context,
        StringConstants.instance.phoneValidMsg,
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

    if (passController!.text.trim() != passConfirmController!.text.trim()) {
      _showErrorDialog(
        context,
        StringConstants.instance.passwordMismatchMsg,
        exitOnClose: false,
      );
      return false;
    }

    return true;
  }

  bool _areRegisterFieldsEmpty() {
    return nameController!.text.trim().isEmpty ||
        surnameController!.text.trim().isEmpty ||
        emailController!.text.trim().isEmpty ||
        phoneController!.text.trim().isEmpty ||
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
        _showErrorDialog(context, errorMessage, exitOnClose: false);
      }
    } catch (e) {
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
      try {
        final profileResult = await _authService.profile();
        if (profileResult.isSuccess && profileResult.hasData) {
          user = _mapUserModelToUserData(profileResult.data?.first);
          if (isSplash == null || isSplash == false) {
            if (context != null && context.mounted) {
              Fluttertoast.showToast(
                msg: StringConstants.instance.successMessage,
                backgroundColor: const Color(0xffFF981A),
                toastLength: Toast.LENGTH_SHORT,
              );
            }
          }
          await _saveUserData(user!);
        } else {
          if (isSplash == null || isSplash == false) {
            if (context != null && context.mounted) {
              Fluttertoast.showToast(
                msg:
                    profileResult.message ??
                    StringConstants.instance.errorMessage,
                backgroundColor: context.colorScheme.error,
                toastLength: Toast.LENGTH_SHORT,
              );
            }
          }
        }
        await profileGetDataShared();
        notifyListeners();
      } catch (e) {
        debugPrint('Profile fetch exception: $e');
      }
    }

    if (context != null && !context.mounted) {
      return;
    }

    await _handleAppVersionCheck(context);

    if (isSplash == true && isAvalibleApp != null) {
      final currentVersion = int.parse(version?.replaceAll(".", "") ?? "0");
      bool shouldNavigateFromVersionCheck = false;

      if (Platform.isAndroid) {
        final androidVersion = isAvalibleApp?.data?.android?.version ?? 0;
        shouldNavigateFromVersionCheck = androidVersion <= currentVersion;
      } else if (Platform.isIOS) {
        final iosVersion = isAvalibleApp?.data?.ios?.version ?? 0;
        shouldNavigateFromVersionCheck = iosVersion <= currentVersion;
      }

      if (shouldNavigateFromVersionCheck) {
        _navigateBasedOnUserStatus();
      }
    }
  }

  Future<void> _handleAppVersionCheck(BuildContext? context) async {
    if (isAvalibleApp == null) {
      try {
        final isAvailableResult = await _authService.isAvalible();
        isAvalibleApp = isAvailableResult;

        if (!isAvailableResult.isSuccess) {
          return;
        }
      } catch (e) {
        return;
      }
    }

    try {
      final currentVersion = int.parse(version?.replaceAll(".", "") ?? "0");
      if (!context!.mounted) return;
      if (Platform.isAndroid) {
        await _handleAndroidVersionCheck(context, currentVersion);
      } else if (Platform.isIOS) {
        await _handleIOSVersionCheck(context, currentVersion);
      }
    } catch (e) {
      //test
    }
  }

  Future<void> _handleAndroidVersionCheck(
    BuildContext? context,
    int currentVersion,
  ) async {
    final androidVersion = isAvalibleApp?.data?.android?.version ?? 0;

    if (androidVersion > currentVersion) {
      _showUpdateDialog(context, isAvalibleApp.data.android!.link);
    }
  }

  Future<void> _handleIOSVersionCheck(
    BuildContext? context,
    int currentVersion,
  ) async {
    final iosVersion = isAvalibleApp?.data?.ios?.version ?? 0;

    if (iosVersion > currentVersion) {
      _showUpdateDialog(context, isAvalibleApp.data.ios!.link);
    }
  }

  void _showUpdateDialog(BuildContext? context, String updateUrl) {
    if (context == null) return;

    DialogFactory.create(
      context: context,
      type: DialogType.update,
      parameters: {
        'message': StringConstants.instance.appMessage,
        'onConfirm': () => UrlLaunch.openUrl(context, updateUrl),
      },
    );
  }

  void _navigateBasedOnUserStatus() {
    Timer(const Duration(seconds: 2), () {
      final storedToken = _storageService.getStringValue(PreferencesKeys.TOKEN);

      if (storedToken.isNotEmpty) {
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
        "Çıkış işlemi sırasında bir hata oluştu",
        exitOnClose: false,
      );
    }
  }

  void clearCache() async {
    await _storageService.clearAll();
    _clearControllers();
    user = null;
    _accessToken = null;
    event = SignStatus.lyLogin;
    notifyListeners();
    navigation.navigateToPageClear(path: NavigationConstants.DEFAULT);
  }

  Future<void> profileSetDataShared(
    BaseModel<List<UserModel>> profileModel,
  ) async {
    final userData = _mapUserModelToUserData(profileModel.data?.first);
    await _saveUserData(userData);
    await profileGetDataShared();
  }

  Future<void> setDataShared(BaseModel<List<UserModel>> loginModel) async {
    if (loginModel.data != null &&
        loginModel.data!.isNotEmpty &&
        loginModel.data!.first.accessToken != null) {
      final userData = _mapUserModelToUserData(loginModel.data?.first);
      await _saveUserData(userData);
      await profileGetDataShared();
    }
  }

  Future<void> profileGetDataShared() async {
    user = await _userDataRepository.getUserData();
    notifyListeners();
  }

  _loadUserDataFromStorage() {
    profileGetDataShared();
    final storedToken = _storageService.getStringValue(PreferencesKeys.TOKEN);
    if (storedToken.isNotEmpty) {
      _accessToken = storedToken;
      event = SignStatus.logined;
    } else {
      _accessToken = null;
      event = SignStatus.lyLogin;
    }
    notifyListeners();
  }

  UserData _mapUserModelToUserData(UserModel? userModel) {
    if (userModel == null) return UserData();

    return UserData(
      id: userModel.id?.toString(),
      username: userModel.name,
      gender: userModel.gender,
      phone: userModel.phone,
      email: userModel.email,
      role: userModel.role?.name,
      accessToken: userModel.accessToken,
      refreshToken: userModel.refreshToken,
      companyName: userModel.company?.name,
      companyAddress: userModel.company?.address,
      startDate: userModel.shift?.start,
      endDate: userModel.shift?.end,
      startTDate: userModel.shift?.tolerance?.start,
      endTDate: userModel.shift?.tolerance?.end,
      department: userModel.department?.name,
      outside: userModel.settings?.outside,
    );
  }

  Future<void> _saveUserData(UserData userData) async {
    try {
      await _userDataRepository.saveUserData(userData);
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  Future<void> _saveUserDataFromModel(BaseModel<List<UserModel>> model) async {
    final userData = _mapUserModelToUserData(model.data?.first);
    await _saveUserData(userData);
  }

  Future<BaseModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (!_isNetworkConnected()) {
      return BaseModel(
        status: false,
        message: StringConstants.instance.networkMsg,
        data: null,
      );
    }

    try {
      final result = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      return result;
    } catch (e) {
      return BaseModel(
        status: false,
        message: StringConstants.instance.errorMessage,
        data: null,
      );
    }
  }
}
