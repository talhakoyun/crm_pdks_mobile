import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/extension/context_extension.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
import '../core/position/location_manager.dart';
import '../viewModel/auth_view_model.dart';
import '../viewModel/in_and_out_view_model.dart';
import '../widgets/error_widget.dart';
import 'drawer_menu_view.dart';

enum AlertCabilitySituation {
  onlineInEvent,
  onlineOutEvent,
  lateInEvent,
  earlyOutEvent,
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with BaseSingleton, SizeSingleton {
  InAndOutViewModel inAndOutViewModel = InAndOutViewModel();
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
    return WillPopScope(
      onWillPop: () async => false,
      child: (inAndOutViewModel.authVM.event == SignStatus.logined)
          ? Scaffold(
              key: inAndOutViewModel.scaffoldKey,
              appBar: AppBar(actions: [outSideArea()]),
              drawer: const DrawerMenuView(),
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
                            'male'
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
                    ),
                  ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget outSideArea() {
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
