import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/base/base_singleton.dart';
import '../core/constants/navigation_constants.dart';
import '../core/enums/enums.dart';
import '../core/extension/context_extension.dart';
import '../viewModel/permissions_view_model.dart';
import '../widgets/error_widget.dart';
import '../widgets/permission_card.dart';

class PermissionProceduresView extends StatefulWidget {
  const PermissionProceduresView({super.key});

  @override
  State<PermissionProceduresView> createState() =>
      _PermissionProceduresViewState();
}

class _PermissionProceduresViewState extends State<PermissionProceduresView>
    with BaseSingleton {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final permissionVM = Provider.of<PermissionViewModel>(
        context,
        listen: false,
      );
      permissionVM.fetchList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    PermissionViewModel permissionVM = Provider.of<PermissionViewModel>(
      context,
    );
    return permissionVM.permissionStatus == PermissionStatus.loaded
        ? Scaffold(
            backgroundColor: context.colorScheme.onTertiaryContainer,
            floatingActionButton: FloatingActionButton(
              backgroundColor: context.colorScheme.primary,
              onPressed: () => permissionVM.navigation.navigateToPage(
                path: NavigationConstants.GETPERM,
              ),
              child: Icon(
                Icons.add,
                color: context.colorScheme.onError,
                size: 35,
              ),
            ),
            body: permissionVM.permissionListItems.isNotEmpty
                ? SafeArea(
                    child: RefreshIndicator(
                      backgroundColor: context.colorScheme.onError,
                      onRefresh: () async {
                        await permissionVM.fetchList(context);
                      },
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        padding: context.paddingNormal,
                        itemCount: permissionVM.permissionListItems.length,
                        itemBuilder: (context, int index) => PermissionCard(
                          item: permissionVM.permissionListItems[index],
                        ),
                      ),
                    ),
                  )
                : _buildEmptyState(context),
          )
        : permissionVM.permissionStatus == PermissionStatus.loadingFailed
        ? errorPageView(
            context: context,
            imagePath: imgCons.warning,
            title: strCons.unExpectedError,
            subtitle: "",
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: context.colorScheme.primary,
                valueColor: AlwaysStoppedAnimation(
                  context.colorScheme.onPrimary,
                ),
                color: context.colorScheme.error,
              ),
            ),
          );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imgCons.permission,
            width: 80,
            height: 80,
            placeholderBuilder: (context) {
              return Icon(
                Icons.assignment_outlined,
                size: 80,
                color: context.colorScheme.onTertiary.withValues(alpha: 0.3),
              );
            },
          ),
          SizedBox(height: context.normalValue),
          Text(
            strCons.noLeaveText,
            style: context.textTheme.headlineSmall!.copyWith(
              color: context.colorScheme.onTertiary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.normalValue),
          Text(
            strCons.permissionCreateRequest,
            style: context.textTheme.bodyLarge!.copyWith(
              color: context.colorScheme.onTertiary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
