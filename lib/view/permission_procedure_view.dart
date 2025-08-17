import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/navigation_constants.dart';
import '../core/enums/enums.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../viewModel/permissions_view_model.dart';
import '../widgets/error_widget.dart';
import '../widgets/permission_listtile.dart';

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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  context.navigationOf.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: context.colorScheme.onTertiary,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () => permissionVM.navigation.navigateToPage(
                    path: NavigationConstants.GETPERM,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      ImageConstants.instance.logo,
                      width: 24.5.scalablePixel,
                    ),
                  ),
                ),
              ],
              title: Text(
                strCons.leavelProsedureText,
                style: context.textTheme.headlineMedium!.copyWith(
                  color: context.colorScheme.onTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: permissionVM.permissionListItems.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: context.paddingLow,
                    itemCount: permissionVM.permissionListItems.length,
                    itemBuilder: (context, int index) => PermissionListTile(
                      type: permissionVM.permissionListItems[index].type?.id,
                      confirmText:
                          permissionVM.permissionListItems[index].statusText ??
                          strCons.unSpecified,
                      endDate:
                          permissionVM.permissionListItems[index].endDate ??
                          strCons.unSpecified,
                      startDate:
                          permissionVM.permissionListItems[index].startDate ??
                          strCons.unSpecified,
                      typeText:
                          permissionVM.permissionListItems[index].type?.title ??
                          strCons.unSpecified,
                      approvalStatus:
                          permissionVM.permissionListItems[index].status ?? 0,
                      address:
                          permissionVM.permissionListItems[index].note ??
                          strCons.unSpecified,
                      reasonText:
                          permissionVM.permissionListItems[index].note ??
                          strCons.unSpecified,
                      iconName:
                          permissionVM
                              .permissionListItems[index]
                              .type
                              ?.iconName ??
                          '',
                    ),
                  )
                : Center(
                    child: Text(
                      strCons.noLeaveText,
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          )
        : permissionVM.permissionStatus == PermissionStatus.loadingFailed
        ? errorPageView(
            context: context,
            imagePath: imgCons.warning,
            title: strCons.unExpectedError,
            subtitle: ' ',
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
}
