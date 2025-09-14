import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/view_model/base_view_model.dart';
import 'auth_view_model.dart';
import 'inandout_list_view_model.dart';
import 'permissions_view_model.dart';

class MainNavigationViewModel extends BaseViewModel {
  int _currentIndex = 0;
  late PageController _pageController;

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

  Future<void> handlePageChange(BuildContext context, int index) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;

    switch (index) {
      case 0:
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        if (authVM.userName == null || authVM.userName!.isEmpty) {
          authVM.getProfile(context, true);
        }
        break;
      case 1:
        final listVM = Provider.of<InAndOutListViewModel>(
          context,
          listen: false,
        );
        listVM.fetchList(context);
        break;
      case 2:
        final permissionVM = Provider.of<PermissionViewModel>(
          context,
          listen: false,
        );
        permissionVM.fetchList(context);
        break;
      case 3:
        break;
    }
  }
}
