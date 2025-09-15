import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/view_model/base_view_model.dart';
import 'auth_view_model.dart';
import 'inandout_list_view_model.dart';
import 'permissions_view_model.dart';

class MainNavigationViewModel extends BaseViewModel {
  int _currentIndex = 0;
  late PageController _pageController;
  
  // Cache için flags
  bool _homeInitialized = false;
  bool _inAndOutInitialized = false;
  bool _permissionInitialized = false;
  
  // Son API çağrılarını track et
  DateTime? _lastHomeRefresh;
  DateTime? _lastInAndOutRefresh;
  DateTime? _lastPermissionRefresh;
  
  static const int _refreshCooldownSeconds = 5; // 5 saniye cooldown

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;

  @override
  void init() {
    _pageController = PageController();
  }

  @override
  void disp() {
    _pageController.dispose();
  }

  void onItemTapped(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      _pageController.jumpToPage(index);
      notifyListeners();
    }
  }

  bool _shouldRefreshData(DateTime? lastRefresh) {
    if (lastRefresh == null) return true;
    return DateTime.now().difference(lastRefresh).inSeconds > _refreshCooldownSeconds;
  }

  Future<void> handlePageChange(BuildContext context, int index) async {
    // Kısa cooldown ile çoklu çağrıları önle
    await Future.delayed(const Duration(milliseconds: 50));
    if (!context.mounted) return;

    switch (index) {
      case 0: // Home
        if (!_homeInitialized || _shouldRefreshData(_lastHomeRefresh)) {
          try {
            final authVM = Provider.of<AuthViewModel>(context, listen: false);
            if (authVM.userName == null || authVM.userName!.isEmpty) {
              await authVM.getProfile(context, false);
              _lastHomeRefresh = DateTime.now();
            }
            _homeInitialized = true;
          } catch (e) {
            debugPrint('Home initialization error: $e');
          }
        }
        break;
        
      case 1: // In and Out List
        if (!_inAndOutInitialized || _shouldRefreshData(_lastInAndOutRefresh)) {
          try {
            final listVM = Provider.of<InAndOutListViewModel>(
              context,
              listen: false,
            );
            listVM.fetchList(context);
            _lastInAndOutRefresh = DateTime.now();
            _inAndOutInitialized = true;
          } catch (e) {
            debugPrint('InAndOut list error: $e');
          }
        }
        break;
        
      case 2: // Permission
        if (!_permissionInitialized || _shouldRefreshData(_lastPermissionRefresh)) {
          try {
            final permissionVM = Provider.of<PermissionViewModel>(
              context,
              listen: false,
            );
            permissionVM.fetchList(context);
            _lastPermissionRefresh = DateTime.now();
            _permissionInitialized = true;
          } catch (e) {
            debugPrint('Permission list error: $e');
          }
        }
        break;
        
      case 3: // Profile - genellikle refresh gerekmez
        break;
    }
  }
  
  // Manual refresh için metodlar
  void forceRefreshHome() {
    _homeInitialized = false;
    _lastHomeRefresh = null;
  }
  
  void forceRefreshInAndOut() {
    _inAndOutInitialized = false;
    _lastInAndOutRefresh = null;
  }
  
  void forceRefreshPermission() {
    _permissionInitialized = false;
    _lastPermissionRefresh = null;
  }
}
