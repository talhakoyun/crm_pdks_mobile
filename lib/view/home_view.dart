import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/enums/preferences_keys.dart';
import '../core/enums/sign_status.dart';
<<<<<<< Updated upstream
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
import '../core/position/location_manager.dart';
=======
import '../core/init/theme/theme_extensions.dart';
import '../core/init/cache/location_manager.dart';
>>>>>>> Stashed changes
import '../viewModel/in_and_out_view_model.dart';
import '../widgets/error_widget.dart';
import 'drawer_menu_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

<<<<<<< Updated upstream
class _HomeViewState extends State<HomeView> with BaseSingleton, SizeSingleton {
  InAndOutViewModel inAndOutViewModel = InAndOutViewModel();
=======
class _HomeViewState extends State<HomeView> with BaseSingleton {
>>>>>>> Stashed changes
  LocationManager locationManager = LocationManager();
  Position? currentPosition;
  bool? isMockLocation;
  StreamController<bool> isOutSide = StreamController<bool>.broadcast();
  @override
  void initState() {
    super.initState();
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
<<<<<<< Updated upstream
              appBar: AppBar(actions: [outSideArea()]),
              drawer: const DrawerMenuView(),
=======
>>>>>>> Stashed changes
              body: ChangeNotifierProvider<LocationManager>(
                create: (BuildContext context) => locationManager,
                child: Consumer<LocationManager>(
                  builder: (context, value, _) {
                    if (!Platform.isIOS) {
                      inAndOutViewModel.buildMethod(context);
                    }
                    if (value.currentPosition == null) {
                      value.determinePosition(context);
                    } else {
                      debugPrint(
                        "latitude: | ${value.currentPosition!.latitude}",
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: context.mediaQuery.size.height,
                            child:
                                (inAndOutViewModel.networkConnectivity.internet)
                                ? (value.currentPosition != null)
                                      ? Padding(
                                          padding: context.onlyTopPaddingHigh,
                                          child: FlutterMap(
                                            options: MapOptions(
                                              initialCenter: LatLng(
                                                value.currentPosition!.latitude,
                                                value
                                                    .currentPosition!
                                                    .longitude,
                                              ),
                                              initialZoom: 18,
                                              maxZoom: 18,
                                            ),
                                            children: [
                                              TileLayer(
                                                urlTemplate: strCons.mapUrl,
                                                subdomains: const [
                                                  'a',
                                                  'b',
                                                  'c',
                                                ],
                                              ),
                                              MarkerLayer(
                                                markers:
                                                    value.currentPosition !=
                                                        null
                                                    ? [
                                                        Marker(
                                                          point: LatLng(
                                                            value
                                                                .currentPosition!
                                                                .latitude,
                                                            value
                                                                .currentPosition!
                                                                .longitude,
                                                          ),
                                                          child: Image(
                                                            image: AssetImage(
                                                              imgCons.marker,
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                    : [],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: Padding(
                                            padding:
                                                context.onlyTopPaddingHigh *
                                                2.5,
                                            child: SvgPicture.asset(
                                              imgCons.noLocation,
                                            ),
                                          ),
                                        )
                                : Center(
                                    child: Padding(
                                      padding: context.onlyTopPaddingHigh * 2.5,
                                      child: SvgPicture.asset(imgCons.offMode),
                                    ),
                                  ),
                          ),
                          buildNavbarArea(context),
                          buildHomeTopContainer(context),
                        ],
                      ),
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

  Widget buildHomeTopContainer(BuildContext context) {
    return SizedBox(
      height: SizerUtil.height > 600
          ? sizeConfig.heightSize(context, 255)
          : sizeConfig.heightSize(context, 280),
      width: SizerUtil.width,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: Container(
          decoration: BoxDecoration(color: context.colorScheme.primary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  context.emptySizedHeightBoxLow2x,
                  Image(
                    image:
                        inAndOutViewModel.localeManager.getStringValue(
                              PreferencesKeys.GENDER,
                            ) ==
                            'Erkek'
                        ? AssetImage(imgCons.male)
                        : AssetImage(imgCons.female),
                    fit: BoxFit.contain,
                    height: sizeConfig.heightSize(context, 80),
                    width: sizeConfig.widthSize(context, 80),
                  ),
                  context.emptySizedHeightBoxLow,
                  Text(
                    inAndOutViewModel.authVM.userName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.primaryTextTheme.headlineSmall,
                  ),
                  Text(
                    inAndOutViewModel.authVM.department!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.primaryTextTheme.bodyLarge,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${strCons.checkInTime}\n',
                              style: context.primaryTextTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text:
                                  inAndOutViewModel.authVM.startDate ??
                                  strCons.unSpecified,
                              style: context.primaryTextTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 5.height,
                        child: VerticalDivider(
                          thickness: 0.5,
                          color: context.colorScheme.onError,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${strCons.checkOutTime}\n',
                              style: context.primaryTextTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text:
                                  inAndOutViewModel.authVM.endDate ??
                                  strCons.unSpecified,
                              style: context.primaryTextTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< Updated upstream
  Widget buildNavbarArea(BuildContext context) {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: context.onlyBottomPaddingNormal,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: sizeConfig.widthSize(context, 260),
              height: sizeConfig.heightSize(context, 80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  tileMode: TileMode.clamp,
                  colors: [
                    context.colorScheme.primary,
                    context.colorScheme.onPrimary,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      inAndOutViewModel.pressLogin(
                        context,
                        inAndOutViewModel.scaffoldKey,
                      );
                    },
                    child: Container(
                      width: 12.5.width,
                      height: 12.5.width,
                      decoration: BoxDecoration(
                        color: context.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Padding(
                        padding: context.paddingLow,
                        child: SvgPicture.asset(imgCons.start),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      inAndOutViewModel.pressQrArea(
                        context,
                        inAndOutViewModel.scaffoldKey,
                      );
                    },
                    child: Container(
                      width: 12.5.width,
                      height: 12.5.width,
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Padding(
                        padding: context.paddingLow,
                        child: SvgPicture.asset(imgCons.qr),
                      ),
=======
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
              backgroundColor: context.colorScheme.surface.withValues(
                alpha: 0.2,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: context.colorScheme.surface,
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
            context.gapXS,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hoş Geldin!",
                    style: context.textTheme.titleLarge!.copyWith(
                      color: context.colorScheme.surface,
                    ),
                  ),
                  context.gapXS,
                  Text(
                    inAndOutViewModel.authVM.userName ?? '',
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.surface,
>>>>>>> Stashed changes
                    ),
                  ),
<<<<<<< Updated upstream
                  GestureDetector(
                    onTap: () {
                      inAndOutViewModel.pressOut(
                        context,
                        inAndOutViewModel.scaffoldKey,
                      );
                    },
                    child: Container(
                      width: 12.5.width,
                      height: 12.5.width,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Padding(
                        padding: context.paddingLow,
                        child: SvgPicture.asset(imgCons.stop),
                      ),
=======
                  context.gapXS,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      inAndOutViewModel.authVM.department ?? 'Departman',
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.surface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
>>>>>>> Stashed changes
                    ),
                  ),
                ],
              ),
            ),
<<<<<<< Updated upstream
=======
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
            inAndOutViewModel.authVM.startDate ?? strCons.unSpecified,
            Icons.login_rounded,
            context.colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTimeCard(
            context,
            strCons.exitTime,
            inAndOutViewModel.authVM.endDate ?? strCons.unSpecified,
            Icons.logout_rounded,
            context.colorScheme.secondary,
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
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            context.gapSM,
            Text(
              time,
              style: context.textTheme.bodyLarge!.copyWith(
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
                context.colorScheme.tertiary,
                () => inAndOutViewModel.pressLogin(
                  context,
                  inAndOutViewModel.scaffoldKey,
                ),
              ),
            ),
            context.gapSM,
            Expanded(
              child: _buildActionButton(
                context,
                "QR Kod",
                Icons.qr_code_scanner_rounded,
                context.colorScheme.primary,
                () => inAndOutViewModel.pressQrArea(
                  context,
                  inAndOutViewModel.scaffoldKey,
                ),
              ),
            ),
            context.gapSM,
            Expanded(
              child: _buildActionButton(
                context,
                "Çıkış Yap",
                Icons.logout_rounded,
                context.colorScheme.secondary,
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
              context.gapSM,
              Text(
                label,
                style: context.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
>>>>>>> Stashed changes
          ),
        ),
      ),
    );
  }

<<<<<<< Updated upstream
  Widget outSideArea() {
=======
  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imgCons.offMode, width: 120, height: 120),
          context.gapLG,
          Text(
            "İnternet bağlantısı yok",
            style: context.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
          context.gapSM,
          Text(
            "Lütfen internet bağlantınızı kontrol edin",
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutsideToggle() {
>>>>>>> Stashed changes
    return StreamBuilder<bool>(
      stream: isOutSide.stream,
      initialData: false,
      builder: (context, snapshot) {
        return InkWell(
          onTap: () {
            isOutSide.sink.add(!snapshot.data!);
            inAndOutViewModel.outSide = (snapshot.data ?? false) ? 0 : 1;
            debugPrint("${inAndOutViewModel.outSide}");
          },
          borderRadius: BorderRadius.circular(15),
          child: Row(
            children: [
              Text(
                strCons.outSideText,
<<<<<<< Updated upstream
                style: context.primaryTextTheme.bodyMedium,
              ),
              Transform.scale(
                scale: 1.1,
                child: Theme(
                  data: context.appTheme.copyWith(
                    unselectedWidgetColor: Colors.white70,
                  ),
                  child: Checkbox(
                    activeColor: context.colorScheme.onSecondary,
                    shape: const CircleBorder(),
                    tristate: false,
                    value: snapshot.hasData ? snapshot.data : false,
                    splashRadius: 30,
                    onChanged: (value) {
                      isOutSide.sink.add(value!);
                      inAndOutViewModel.outSide = (value) ? 1 : 0;
                      debugPrint("${inAndOutViewModel.outSide}");
                    },
                  ),
=======
                style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
>>>>>>> Stashed changes
                ),
              ),
            ],
          ),
        );
      },
    );
  }
<<<<<<< Updated upstream
=======

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
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.dashboard_rounded,
                    color: context.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Günlük Dashboard",
                  style: context.textTheme.titleMedium!.copyWith(
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
                        ? context.colorScheme.tertiary.withValues(alpha: 0.1)
                        : context.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    todayStatus,
                    style: context.textTheme.labelSmall!.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: todayStatus == "Zamanında"
                          ? context.colorScheme.tertiary
                          : context.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
            context.gapMD,
            Row(
              children: [
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    "Giriş Saati",
                    shiftStart,
                    Icons.login_rounded,
                    context.colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    "Şu An",
                    currentTime,
                    Icons.access_time_rounded,
                    context.colorScheme.primary,
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
                    context.colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardItem(
                    context,
                    "Çıkış Saati",
                    shiftEnd,
                    Icons.logout_rounded,
                    context.colorScheme.primaryContainer,
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
          context.gapXS,
          Text(
            label,
            style: context.textTheme.labelSmall!.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          context.gapXS,
          Text(
            value,
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
>>>>>>> Stashed changes
}
