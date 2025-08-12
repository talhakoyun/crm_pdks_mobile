import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
import '../viewModel/auth_view_model.dart';
import '../widgets/text_input/profile_text_input.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with BaseSingleton, SizeSingleton {
  AuthViewModel authViewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (BuildContext context) => authViewModel,
      child: Consumer<AuthViewModel>(
        builder: (context, value, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  context.navigationOf.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: context.colorScheme.surface,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(msg: strCons.profileLoading);
                    value.getProfile(context, false);
                  },
                  icon: Icon(Icons.refresh, color: context.colorScheme.surface),
                ),
              ],
            ),
            body: Container(
              margin: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  Image.asset(
                    value.gender == "male" ? imgCons.male : imgCons.female,
                    height: sizeConfig.widthSize(context, 90),
                    width: sizeConfig.widthSize(context, 90),
                  ),
                  context.emptySizedHeightBoxLow2x,
                  Text(
                    value.userName!,
                    style: context.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    value.department!,
                    style: context.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  context.emptySizedHeightBoxHigh,
                  ProfileTextInput(
                    title: strCons.phone,
                    description: value.phone,
                    heightCon: Platform.isIOS
                        ? SizerUtil.height > 670
                              ? sizeConfig.heightSize(context, 60)
                              : sizeConfig.heightSize(context, 75)
                        : SizerUtil.height > 535
                        ? sizeConfig.heightSize(context, 65)
                        : sizeConfig.heightSize(context, 80),
                    icon: Icons.phone_iphone_rounded,
                    iconSize: 22.scalablePixel,
                  ),
                  context.emptySizedHeightBoxLow2x,
                  ProfileTextInput(
                    title: strCons.email,
                    description: value.email,
                    heightCon: Platform.isIOS
                        ? SizerUtil.height > 670
                              ? sizeConfig.heightSize(context, 60)
                              : sizeConfig.heightSize(context, 75)
                        : SizerUtil.height > 535
                        ? sizeConfig.heightSize(context, 65)
                        : sizeConfig.heightSize(context, 80),
                    icon: Icons.mail,
                    iconSize: 22.scalablePixel,
                  ),
                  context.emptySizedHeightBoxLow2x,
                  ProfileTextInput(
                    title: strCons.gender,
                    description: value.gender,
                    heightCon: Platform.isIOS
                        ? SizerUtil.height > 670
                              ? sizeConfig.heightSize(context, 60)
                              : sizeConfig.heightSize(context, 75)
                        : SizerUtil.height > 535
                        ? sizeConfig.heightSize(context, 65)
                        : sizeConfig.heightSize(context, 80),
                    icon: Icons.transgender_sharp,
                    iconSize: 22.scalablePixel,
                  ),
                  context.emptySizedHeightBoxLow2x,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
