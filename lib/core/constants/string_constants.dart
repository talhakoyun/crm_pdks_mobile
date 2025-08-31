import 'package:easy_localization/easy_localization.dart';

class StringConstants {
  static StringConstants? _instance;

  static StringConstants get instance => _instance ??= StringConstants._init();

  StringConstants._init();

  // App related
  String get appName => "app.name".tr();
  String get appVersionText => "app.version".tr();
  String get appMessage => "app.message".tr();

  // General
  String get begining => "general.beginning".tr();
  String get choose => "general.choose".tr();
  String get description => "general.description".tr();
  String get finish => "general.finish".tr();
  String get mission => "general.mission".tr();
  String get gender => "general.gender".tr();
  String get name => "general.name".tr();
  String get send => "general.send".tr();
  String get shift => "general.shift".tr();
  String get okey => "general.ok".tr();
  String get dateText => "general.date".tr();
  String get notEmptyText => "general.notEmpty".tr();
  String get unSpecified => "general.unSpecified".tr();
  String get unExpectedError => "general.unExpectedError".tr();
  String get errorMessage => "general.errorMessage".tr();
  String get errorMessageContinue => "general.errorMessageContinue".tr();

  // Auth
  String get email => "auth.email".tr();
  String get password => "auth.password".tr();
  String get passwordConfirm => "auth.passwordConfirm".tr();
  String get phone => "auth.phone".tr();
  String get welcome => "auth.welcome".tr();
  String get welcomeText => "auth.welcomeText".tr();
  String get loginText => "auth.login".tr();
  String get signUp => "auth.signUp".tr();
  String get signUpText => "auth.signUpText".tr();
  String get signUpBtnText => "auth.signUpBtn".tr();
  String get dontAccount => "auth.dontAccount".tr();
  String get newAccount => "auth.newAccount".tr();
  String get logOutText => "auth.logout".tr();
  String get exitTitle => "auth.exitTitle".tr();
  String get exitInfo => "auth.exitInfo".tr();

  // Profile
  String get profileText => "profile.profile".tr();
  String get profileLoading => "profile.loading".tr();

  // Company
  String get companyText => "company.text".tr();
  String get splashFooter => "company.splashFooter".tr();
  String get outSideText => "company.outSide".tr();

  // Splash
  String get splashText1 => "splash.text1".tr();
  String get splashText2 => "splash.text2".tr();

  // Menu
  String get inAndOutText => "menu.inAndOut".tr();
  String get leavelProsedureText => "menu.leavelProcedure".tr();

  // Time
  String get inTime => "time.in".tr();
  String get outTime => "time.out".tr();
  String get checkInTime => "time.checkIn".tr();
  String get checkOutTime => "time.checkOut".tr();
  String get monthlyData => "time.monthly".tr();

  // Leave
  String get leaveText => "leave.type".tr();
  String get leaveStartText => "leave.start".tr();
  String get leaveReasonText => "leave.reason".tr();
  String get moveAddressText => "leave.address".tr();
  String get getLeavePermissionText => "leave.getPermission".tr();
  String get noLeaveText => "leave.noLeave".tr();

  // In/Out
  String get inText => "inOut.in".tr();
  String get outText => "inOut.out".tr();
  String get noInAndOutText => "inOut.noInAndOut".tr();

  // Late
  String get lateText => "late.text".tr();
  String get lateDescription => "late.description".tr();

  // Early
  String get earlyText => "early.text".tr();
  String get earlyDescription => "early.description".tr();

  // Buttons
  String get cancelText => "buttons.cancel".tr();
  String get cancelText2 => "buttons.cancel2".tr();
  String get approveButtonText => "buttons.approve".tr();
  String get cancelButtonText => "buttons.cancel_btn".tr();
  String get confirmText => "buttons.confirm".tr();
  String get confirmText2 => "buttons.confirm2".tr();

  // Messages
  String get successMessage => "messages.success".tr();
  String get successMessage2 => "messages.success2".tr();
  String get outSuccessMessage => "messages.outSuccess".tr();
  String get loginSuccessMsg => "messages.loginSuccess".tr();
  String get reviewText => "messages.review".tr();
  String get networkMsg => "messages.network".tr();
  String get warningMessage1 => "messages.warning1".tr();

  // Errors
  String get qrErrorMessage => "errors.qr".tr();
  String get qrErrorMsg => "errors.qrError".tr();
  String get inErrorMessage => "errors.inError".tr();
  String get outErrorMessage => "errors.outError".tr();
  String get locationError => "errors.location".tr();
  String get locationErrorMsg => "errors.locationError".tr();
  String get loginErrorMsg => "errors.loginError".tr();
  String get loginErrorMsg2 => "errors.loginError2".tr();
  String get emailValidMsg => "errors.emailValid".tr();
  String get passwordValidMsg => "errors.passwordValid".tr();
  String get registerNameErrorMsg => "errors.registerNameError".tr();

  // Location
  String get isEnableLocationAlertText => "location.isEnableAlert".tr();
  String get isNotEnableLocationAlertText => "location.isNotEnableAlert".tr();
  String get isMockLocationPermissionTitle => "location.isMockTitle".tr();
  String get isMockLocationPermissionDescription =>
      "location.isMockDescription".tr();

  // Security
  String get hackText => "security.hack".tr();

  // Dialog
  String get dialogAlertDescription => "dialog.alertDescription".tr();
  String get nonAppRedirect => "dialog.nonAppRedirect".tr();
  String get enterTheAdress => "dialog.enterTheAddress".tr();
  String get qrTypeSelectionText => "dialog.qrTypeSelection".tr();
  String get qrEntryActionText => "dialog.qrEntryAction".tr();
  String get qrExitActionText => "dialog.qrExitAction".tr();
  String get dialogErrorTitle => "dialog.error".tr();
  String get dialogSuccessTitle => "dialog.success".tr();
  String get dialogCloseText => "dialog.close".tr();
  String get dialogUpdateText => "dialog.update".tr();

  // URLs - These should remain as static values
  String get mapUrl =>
      "https://mt0.google.com/vt/lyrs=p&x={x}&y={y}&z={z}&s=Ga";

  String determineString(int index) {
    switch (index) {
      case 0:
        return "status.pending".tr();
      case 1:
        return "status.approved".tr();
      case 2:
        return "status.denied".tr();
      default:
        return "status.pending".tr();
    }
  }

  // API URLs - These remain as static strings
  final String baseUrl = "https://crm.mavihost.com.tr/api/";
  final String loginUrl = 'auth/login';
  final String logout = 'auth/logout';
  final String profile = "user/profile";
  final String permissionList = "holidays/list";
  final String holidayTypeList = "holidays/types";
  final String permissionCreate = "holidays/store";
  final String shiftPing = "shift/follow/store";
  final String shiftQR = "shift/follow/qr/store";
  final String shiftList = "shift/follow/list";
  final String isAvalible = "isavailable";
  final String register = "auth/register";
  final String refreshToken = "auth/refresh";
}
