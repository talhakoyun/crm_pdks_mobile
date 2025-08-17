import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/extension/context_extension.dart';
import '../core/init/network/connectivity/network_connectivity.dart';
import '../viewModel/auth_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with BaseSingleton, SizeSingleton {
  final viewModel = AuthViewModel();
  late NetworkConnectivity networkConnectivity;
  @override
  initState() {
    super.initState();
    viewModel.init();
    viewModel.splashCheck(context);
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.disp();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: context.colorScheme.primary,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imgCons.splashLogo,
                      width: sizeConfig.widthSize(context, 115),
                      height: sizeConfig.heightSize(context, 145),
                    ),
                    context.emptySizedHeightBoxLow3x,
                    Text(
                      strCons.appName,
                      style: context.primaryTextTheme.headlineLarge!.copyWith(
                        letterSpacing: 5,
                        fontSize: 45,
                      ),
                    ),
                    context.emptySizedHeightBoxLow,
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text.rich(
                        TextSpan(
                          text:
                              "${strCons.splashText1} "
                              "${strCons.splashText2}",
                        ),
                        style: context.primaryTextTheme.bodyMedium!.copyWith(
                          letterSpacing: 0.75,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Text.rich(
                      TextSpan(
                        text: strCons.companyText,
                        style: context.primaryTextTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: strCons.splashFooter,
                            style: context.primaryTextTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
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
