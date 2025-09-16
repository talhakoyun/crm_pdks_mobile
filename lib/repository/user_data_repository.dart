import '../core/enums/preferences_keys.dart';
import '../core/init/cache/locale_manager.dart';
import '../models/user_data.dart';

class UserDataRepository {
  final LocaleManager _storageService;

  UserDataRepository(this._storageService);

  Future<void> saveUserData(UserData userData) async {
    await _storageService.setStringValue(PreferencesKeys.ID, userData.id ?? "");
    await _storageService.setStringValue(
      PreferencesKeys.USERNAME,
      userData.username ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.GENDER,
      userData.gender ?? "",
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
      PreferencesKeys.TOKEN,
      userData.accessToken ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.REFRESH_TOKEN,
      userData.refreshToken ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.COMPNAME,
      userData.companyName ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.COMPADDRESS,
      userData.companyAddress ?? "",
    );
    await _storageService.setStringValue(
      PreferencesKeys.STARTDATE,
      userData.startDate ?? "-",
    );
    await _storageService.setStringValue(
      PreferencesKeys.ENDDATE,
      userData.endDate ?? "-",
    );
    await _storageService.setStringValue(
      PreferencesKeys.STARTTDATE,
      userData.startTDate ?? "-",
    );
    await _storageService.setStringValue(
      PreferencesKeys.ENDTDATE,
      userData.endTDate ?? "-",
    );
    await _storageService.setStringValue(
      PreferencesKeys.DEPARTMENT,
      userData.department ?? "",
    );
    await _storageService.setBoolValue(
      PreferencesKeys.OUTSIDE,
      userData.outside ?? false,
    );
  }

  Future<UserData> getUserData() async {
    return UserData(
      id: _storageService.getStringValue(PreferencesKeys.ID),
      username: _storageService.getStringValue(PreferencesKeys.USERNAME),
      gender: _storageService.getStringValue(PreferencesKeys.GENDER),
      phone: _storageService.getStringValue(PreferencesKeys.PHONE),
      email: _storageService.getStringValue(PreferencesKeys.EMAIL),
      role: _storageService.getStringValue(PreferencesKeys.ROLE),
      accessToken: _storageService.getStringValue(PreferencesKeys.TOKEN),
      refreshToken: _storageService.getStringValue(
        PreferencesKeys.REFRESH_TOKEN,
      ),
      companyName: _storageService.getStringValue(PreferencesKeys.COMPNAME),
      companyAddress: _storageService.getStringValue(
        PreferencesKeys.COMPADDRESS,
      ),
      startDate: _storageService.getStringValue(PreferencesKeys.STARTDATE),
      endDate: _storageService.getStringValue(PreferencesKeys.ENDDATE),
      startTDate: _storageService.getStringValue(PreferencesKeys.STARTTDATE),
      endTDate: _storageService.getStringValue(PreferencesKeys.ENDTDATE),
      department: _storageService.getStringValue(PreferencesKeys.DEPARTMENT),
      outside: _storageService.getBoolValue(PreferencesKeys.OUTSIDE),
    );
  }

  Future<void> clearUserData() async {
    await _storageService.removeValue(PreferencesKeys.ID);
    await _storageService.removeValue(PreferencesKeys.USERNAME);
    await _storageService.removeValue(PreferencesKeys.GENDER);
    await _storageService.removeValue(PreferencesKeys.PHONE);
    await _storageService.removeValue(PreferencesKeys.EMAIL);
    await _storageService.removeValue(PreferencesKeys.ROLE);
    await _storageService.removeValue(PreferencesKeys.TOKEN);
    await _storageService.removeValue(PreferencesKeys.REFRESH_TOKEN);
    await _storageService.removeValue(PreferencesKeys.COMPNAME);
    await _storageService.removeValue(PreferencesKeys.COMPADDRESS);
    await _storageService.removeValue(PreferencesKeys.STARTDATE);
    await _storageService.removeValue(PreferencesKeys.ENDDATE);
    await _storageService.removeValue(PreferencesKeys.STARTTDATE);
    await _storageService.removeValue(PreferencesKeys.ENDTDATE);
    await _storageService.removeValue(PreferencesKeys.DEPARTMENT);
    await _storageService.removeValue(PreferencesKeys.OUTSIDE);
  }
}
