import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/navigation_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../viewModel/auth_view_model.dart';
import '../viewModel/inandout_list_view_model.dart';
import '../viewModel/permissions_view_model.dart';
import '../widgets/custom_listtile.dart';

class DrawerMenuView extends StatefulWidget {
  const DrawerMenuView({super.key});

  @override
  State<DrawerMenuView> createState() => _DrawerMenuViewState();
}

class _DrawerMenuViewState extends State<DrawerMenuView>
    with BaseSingleton, SizeSingleton {
  AuthViewModel authVM = AuthViewModel();
  @override
  Widget build(BuildContext context) {
    PermissionViewModel permissionVM = Provider.of<PermissionViewModel>(
      context,
    );
    InAndOutListViewModel listVM = Provider.of<InAndOutListViewModel>(context);

    return SafeArea(
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(25),
          ),
        ),
        backgroundColor: context.colorScheme.onError,
        width: sizeConfig.widthSize(context, 260),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15.scalablePixel),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ChangeNotifierProvider<AuthViewModel>(
                  create: (BuildContext context) => authVM,
                  child: Consumer<AuthViewModel>(
                    builder: (context, value, _) {
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25,
                            child: Image.asset(
                              value.gender == 'Erkek'
                                  ? ImageConstants.instance.male
                                  : ImageConstants.instance.female,
                              height: sizeConfig.widthSize(context, 45),
                              width: sizeConfig.widthSize(context, 45),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value.userName!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: context.textTheme.headlineMedium!
                                      .copyWith(
                                        color:
                                            context.colorScheme.errorContainer,
                                      ),
                                ),
                                const SizedBox(height: 1),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SizedBox(
                                    width: 30.width,
                                    child: Text(
                                      '${value.department}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              CustomListTile(
                onTap: () {
                  authVM.navigation.navigateToPage(
                    path: NavigationConstants.PROFILE,
                  );
                },
                text: StringConstants.instance.profileText,
                iconPath: ImageConstants.instance.user,
                width: sizeConfig.widthSize(context, 208),
                height: sizeConfig.heightSize(context, 50),
              ),
              context.emptySizedHeightBoxLow,
              CustomListTile(
                onTap: () {
                  listVM.fetchList(context);
                  listVM.navigation.navigateToPage(
                    path: NavigationConstants.INANDOUTS,
                  );
                },
                text: StringConstants.instance.inAndOutText,
                iconPath: ImageConstants.instance.stop,
                width: sizeConfig.widthSize(context, 208),
                height: sizeConfig.heightSize(context, 50),
              ),
              context.emptySizedHeightBoxLow,
              CustomListTile(
                onTap: () {
                  permissionVM.fetchList(context);
                  permissionVM.navigation.navigateToPage(
                    path: NavigationConstants.PERMISSION,
                  );
                },
                text: StringConstants.instance.leavelProsedureText,
                iconPath: ImageConstants.instance.permission,
                width: sizeConfig.widthSize(context, 208),
                height: sizeConfig.heightSize(context, 50),
              ),
              context.emptySizedHeightBoxLow,
              Expanded(
                flex: 9,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: CustomListTile(
                    onTap: () {
                      logoutAlert(authVM: authVM);
                      permissionVM.permissionListItems.clear();
                    },
                    text: StringConstants.instance.logOutText,
                    iconPath: ImageConstants.instance.logout,
                    width: sizeConfig.widthSize(context, 208),
                    height: sizeConfig.heightSize(context, 50),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: Text.rich(
                      TextSpan(text: "${strCons.appVersionText}: 1.0.0"),
                      style: context.textTheme.bodyMedium!.copyWith(
                        letterSpacing: 0.75,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logoutAlert({required AuthViewModel authVM}) async {
    return showDialog<void>(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    text: strCons.exitTitle,
                    children: [
                      const WidgetSpan(child: SizedBox(height: 25)),
                      TextSpan(
                        text: strCons.exitInfo,
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    authVM.fetchLogout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.error,
                  ),
                  child: Text(
                    StringConstants.instance.logOutText,
                    style: context.primaryTextTheme.bodyMedium,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                  ),
                  child: Text(
                    StringConstants.instance.cancelButtonText,
                    style: context.primaryTextTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
