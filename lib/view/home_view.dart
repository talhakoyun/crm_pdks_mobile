import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/constants/size_config.dart';

import '../core/position/location_manager.dart';
import '../viewModel/auth_view_model.dart';
import '../viewModel/in_and_out_view_model.dart';
import '../view/drawer_menu_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late InAndOutViewModel inAndOutViewModel;
  late LocationManager locationManager;
  late SizeConfig sizeConfig;
  late ImageConstants imgCons;
  late StringConstants strCons;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  StreamController<bool> isOutSide = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    inAndOutViewModel = InAndOutViewModel();
    locationManager = LocationManager();
    sizeConfig = SizeConfig.instance;
    imgCons = ImageConstants.instance;
    strCons = StringConstants.instance;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    isOutSide.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: (inAndOutViewModel.authVM.event == SignStatus.logined)
          ? Scaffold(
              key: inAndOutViewModel.scaffoldKey,
              backgroundColor: const Color(0xFFF8FAFC),
              appBar: _buildModernAppBar(context),
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
                    }
                    return _buildModernBody(context, value);
                  },
                ),
              ),
            )
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merhaba 👋',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            inAndOutViewModel.authVM.userName ?? 'Kullanıcı',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: outSideArea(),
        ),
      ],
    );
  }

  Widget _buildModernBody(BuildContext context, LocationManager value) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
        ),
        child: Column(
          children: [
            // Status Card
            _buildStatusCard(context),
            const SizedBox(height: 20),
            // Map Section
            Expanded(flex: 2, child: _buildMapSection(context, value)),
            const SizedBox(height: 20),
            // Action Buttons
            _buildActionButtons(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bugünkü Durum',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  inAndOutViewModel.authVM.department ?? 'Departman',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Aktif',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(BuildContext context, LocationManager value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: (inAndOutViewModel.networkConnectivity.internet)
            ? (value.currentPosition != null)
                  ? FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          value.currentPosition!.latitude,
                          value.currentPosition!.longitude,
                        ),
                        initialZoom: 18,
                        maxZoom: 18,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: strCons.mapUrl,
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                value.currentPosition!.latitude,
                                value.currentPosition!.longitude,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4F46E5),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF4F46E5),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF4F46E5),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Konum alınıyor...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'İnternet bağlantısı yok',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context: context,
              title: 'Giriş Yap',
              icon: Icons.login_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              onTap: () {
                inAndOutViewModel.pressLogin(
                  context,
                  inAndOutViewModel.scaffoldKey,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              context: context,
              title: 'QR Okut',
              icon: Icons.qr_code_scanner_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              ),
              onTap: () {
                inAndOutViewModel.pressQrArea(
                  context,
                  inAndOutViewModel.scaffoldKey,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              context: context,
              title: 'Çıkış Yap',
              icon: Icons.logout_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
              onTap: () {
                inAndOutViewModel.pressOut(
                  context,
                  inAndOutViewModel.scaffoldKey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget outSideArea() {
    return StreamBuilder<bool>(
      stream: isOutSide.stream,
      initialData: false,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            isOutSide.sink.add(!snapshot.data!);
            inAndOutViewModel.outSide = (snapshot.data ?? false) ? 0 : 1;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (snapshot.data ?? false)
                  ? const Color(0xFF10B981).withValues(alpha: 0.2)
                  : const Color(0xFFEF4444).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (snapshot.data ?? false)
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  (snapshot.data ?? false)
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: (snapshot.data ?? false)
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  (snapshot.data ?? false) ? 'Dışarıda' : 'İçeride',
                  style: TextStyle(
                    color: (snapshot.data ?? false)
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
