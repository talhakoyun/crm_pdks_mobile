import 'dart:async';

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

class _HomeViewState extends State<HomeView>
    with BaseSingleton, SizeSingleton, AutomaticKeepAliveClientMixin {
  LocationManager locationManager = LocationManager();
  late InAndOutViewModel inAndOutViewModel;
  Position? currentPosition;
  bool? isMockLocation;
  StreamController<bool> isOutSide = StreamController<bool>.broadcast();
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (!_isInitialized) {
      inAndOutViewModel = InAndOutViewModel(locationManager: locationManager);
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeLocationAsync();
      });
    }
  }

  Future<void> _initializeLocationAsync() async {
    if (mounted) {
      await locationManager.determinePosition(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    isOutSide.close();
    if (_isInitialized) {
      locationManager.disp();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PopScope(
      canPop: false,
      child: (inAndOutViewModel.authVM.event == SignStatus.logined)
          ? Scaffold(
              key: inAndOutViewModel.scaffoldKey,
              backgroundColor: context.colorScheme.onTertiaryContainer,
              body: _buildOptimizedBody(),
            )
          : _buildLoadingOrErrorState(),
    );
  }

  Widget _buildOptimizedBody() {
    return ChangeNotifierProvider<LocationManager>.value(
      value: locationManager,
      child: Consumer<LocationManager>(
        builder: (context, locationValue, child) {
          if (locationValue.currentPosition == null && mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                locationValue.determinePosition(context);
              }
            });
          }

          return SafeArea(child: _buildMainContent(context, locationValue));
        },
      ),
    );
  }

  Widget _buildLoadingOrErrorState() {
    if (!inAndOutViewModel.networkConnectivity.internet) {
      return Scaffold(
        body: errorPageView(
          context: context,
          imagePath: imgCons.warning,
          title: strCons.unExpectedError,
          subtitle: "",
        ),
      );
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
          const SizedBox(height: 12),
          _buildStatusCards(context),
          const SizedBox(height: 12),
          _buildActionButtons(context, locationValue),
          const SizedBox(height: 12),
          _buildDailyDashboard(context),
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
            context.emptySizedWidthBoxLow,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strCons.homeWelcome,
                    style: context.primaryTextTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    inAndOutViewModel.authVM.userName ?? '',
                    style: context.primaryTextTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
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
                      inAndOutViewModel.authVM.department ??
                          strCons.homeDepartment,
                      style: context.primaryTextTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildOutsideToggle(),
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
            inAndOutViewModel.authVM.startDate ?? "-",
            Icons.login_rounded,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTimeCard(
            context,
            strCons.exitTime,
            inAndOutViewModel.authVM.endDate ?? "-",
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
                strCons.homeLogin,
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
                strCons.homeQrCode,
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
                strCons.homeLogout,
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
            strCons.homeNoInternet,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strCons.homeCheckInternet,
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
        return ElevatedButton(
          onPressed: () {
            isOutSide.sink.add(!isActive);
            inAndOutViewModel.outSide = isActive ? 0 : 1;
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),
            backgroundColor: context.colorScheme.secondary,
            foregroundColor: context.colorScheme.onSecondary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive
                    ? Icons.location_on_rounded
                    : Icons.location_off_rounded,
                color: context.colorScheme.onError,
                size: 14,
              ),
              Text(
                strCons.outSideText,
                style: context.primaryTextTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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

    // ViewModel'den gelen saat bilgilerini kullan
    final String? shiftStart = inAndOutViewModel.authVM.startDate;
    final String? shiftEnd = inAndOutViewModel.authVM.endDate;

    // Eğer saat bilgileri boşsa "Belirtilmemiş" göster
    if (shiftStart == null || shiftEnd == null) {
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
                    strCons.homeDailyDashboard,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardItem(
                      context,
                      strCons.entryTime,
                      shiftStart ?? strCons.unSpecified,
                      Icons.login_rounded,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardItem(
                      context,
                      strCons.homeCurrentTime,
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
                      strCons.homeRemainingTime,
                      strCons.unSpecified,
                      Icons.timer_rounded,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardItem(
                      context,
                      strCons.exitTime,
                      shiftEnd ?? strCons.unSpecified,
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

    final List<String> shiftStartTimeParts = shiftStart.split(':');
    if (shiftStartTimeParts.length < 2) {
      return _buildDefaultDashboard(context, currentTime);
    }

    final List<String> shiftEndTimeParts = shiftEnd.split(':');
    if (shiftEndTimeParts.length < 2) {
      return _buildDefaultDashboard(context, currentTime);
    }

    final int shiftEndHour = int.tryParse(shiftEndTimeParts[0]) ?? 18;
    final int shiftEndMinute = int.tryParse(shiftEndTimeParts[1]) ?? 0;
    int remainingHours = shiftEndHour - now.hour;
    int remainingMinutes = shiftEndMinute - now.minute;

    if (remainingMinutes < 0) {
      remainingHours--;
      remainingMinutes += 60;
    }

    if (remainingHours < 0) {
      remainingHours = 0;
      remainingMinutes = 0;
    }

    final String remainingTime = "$remainingHours sa. $remainingMinutes dk.";
    final String todayStatus =
        now.isAfter(
          DateTime(now.year, now.month, now.day, shiftEndHour, shiftEndMinute),
        )
        ? strCons.lateText
        : strCons.earlyText;

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
                  strCons.homeDailyDashboard,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: todayStatus == strCons.earlyText
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    todayStatus,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: todayStatus == strCons.earlyText
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
                    strCons.entryTime,
                    shiftStart,
                    Icons.login_rounded,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    strCons.homeCurrentTime,
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
                    strCons.homeRemainingTime,
                    remainingTime,
                    Icons.timer_rounded,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    strCons.exitTime,
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

  Widget _buildDefaultDashboard(BuildContext context, String currentTime) {
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
                  strCons.homeDailyDashboard,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    strCons.entryTime,
                    strCons.unSpecified,
                    Icons.login_rounded,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    strCons.homeCurrentTime,
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
                    strCons.homeRemainingTime,
                    strCons.unSpecified,
                    Icons.timer_rounded,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    strCons.exitTime,
                    strCons.unSpecified,
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
