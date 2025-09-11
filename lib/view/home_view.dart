import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/enums/preferences_keys.dart';
import '../core/enums/sign_status.dart';
import '../core/extension/context_extension.dart';
import '../core/init/cache/location_manager.dart';
import '../viewModel/in_and_out_view_model.dart';
import '../widgets/error_widget.dart';

class HomeView extends StatefulWidget {
  final bool showAppBar;

  const HomeView({super.key, this.showAppBar = true});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with BaseSingleton, SizeSingleton {
  LocationManager locationManager = LocationManager();
  late InAndOutViewModel inAndOutViewModel;
  Position? currentPosition;
  bool? isMockLocation;
  StreamController<bool> isOutSide = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    inAndOutViewModel = InAndOutViewModel(locationManager: locationManager);
    // inAndOutViewModel.pushSignalService();
  }

  @override
  void dispose() {
    super.dispose();
    locationManager.disp();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: (inAndOutViewModel.authVM.event == SignStatus.logined)
          ? Scaffold(
              key: inAndOutViewModel.scaffoldKey,
              backgroundColor: context.colorScheme.onTertiaryContainer,
              appBar: widget.showAppBar
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: Colors.white,
                      actions: [_buildOutsideToggle()],
                    )
                  : null,
              body: ChangeNotifierProvider<LocationManager>(
                create: (BuildContext context) => locationManager,
                child: Consumer<LocationManager>(
                  builder: (context, locationValue, _) {
                    if (!Platform.isIOS) {
                      inAndOutViewModel.buildMethod(context);
                    }
                    if (locationValue.currentPosition == null) {
                      locationValue.determinePosition(context);
                    }

                    return SafeArea(
                      child: _buildMainContent(context, locationValue),
                    );
                  },
                ),
              ),
            )
          : !(inAndOutViewModel.networkConnectivity.internet)
          ? errorPageView(
              context: context,
              imagePath: imgCons.warning,
              title: strCons.unExpectedError,
              subtitle: ' ',
            )
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    LocationManager locationValue,
  ) {
    if (!inAndOutViewModel.networkConnectivity.internet) {
      return _buildNoInternetView();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfoCard(context),
          const SizedBox(height: 24),
          _buildStatusCards(context),
          const SizedBox(height: 24),
          _buildActionButtons(context, locationValue),
          const SizedBox(height: 24),
          _buildDailyDashboard(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colorScheme.primary,
              context.colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Image(
                  image:
                      inAndOutViewModel.localeManager.getStringValue(
                            PreferencesKeys.GENDER,
                          ) ==
                          'Erkek'
                      ? AssetImage(imgCons.male)
                      : AssetImage(imgCons.female),
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hoş Geldin!",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    inAndOutViewModel.authVM.userName ?? 'Kullanıcı',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      inAndOutViewModel.authVM.department ?? 'Departman',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeCard(
            context,
            strCons.entryTime,
            inAndOutViewModel.authVM.startDate ?? strCons.unSpecified,
            Icons.login_rounded,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTimeCard(
            context,
            strCons.exitTime,
            inAndOutViewModel.authVM.endDate ?? strCons.unSpecified,
            Icons.logout_rounded,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.colorScheme.onTertiaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    LocationManager locationValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                "Giriş Yap",
                Icons.login_rounded,
                Colors.green,
                () => inAndOutViewModel.pressLogin(
                  context,
                  inAndOutViewModel.scaffoldKey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                "QR Kod",
                Icons.qr_code_scanner_rounded,
                Colors.blue,
                () => inAndOutViewModel.pressQrArea(
                  context,
                  inAndOutViewModel.scaffoldKey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                "Çıkış Yap",
                Icons.logout_rounded,
                Colors.orange,
                () => inAndOutViewModel.pressOut(
                  context,
                  inAndOutViewModel.scaffoldKey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.colorScheme.onTertiaryContainer,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imgCons.offMode, width: 120, height: 120),
          const SizedBox(height: 24),
          Text(
            "İnternet bağlantısı yok",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Lütfen internet bağlantınızı kontrol edin",
            style: TextStyle(
              fontSize: 14,
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutsideToggle() {
    return StreamBuilder<bool>(
      stream: isOutSide.stream,
      initialData: false,
      builder: (context, snapshot) {
        final isActive = snapshot.data ?? false;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
            onTap: () {
              isOutSide.sink.add(!isActive);
              inAndOutViewModel.outSide = isActive ? 0 : 1;
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive
                        ? Icons.location_on_rounded
                        : Icons.location_off_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    strCons.outSideText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyDashboard(BuildContext context) {
    // Gerçek zamanlı veriler - API'den gelecek
    final DateTime now = DateTime.now();
    final String currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    const String shiftStart = "09:00";
    const String shiftEnd = "18:00";
    const int remainingHours = 3;
    const int remainingMinutes = 45;
    const String todayStatus = "Zamanında"; // Geç/Zamanında

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.colorScheme.onTertiaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.dashboard_rounded,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Günlük Dashboard",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: todayStatus == "Zamanında"
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    todayStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: todayStatus == "Zamanında"
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    "Giriş Saati",
                    shiftStart,
                    Icons.login_rounded,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    "Şu An",
                    currentTime,
                    Icons.access_time_rounded,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    "Kalan Süre",
                    "${remainingHours}s ${remainingMinutes}dk",
                    Icons.timer_rounded,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    "Çıkış Saati",
                    shiftEnd,
                    Icons.logout_rounded,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
