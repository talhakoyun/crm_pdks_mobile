import 'package:crm_pdks_mobile/core/init/theme/app_constants.dart';
import 'package:flutter/material.dart';

import '../constants/image_constants.dart';
import '../init/theme/theme_extensions.dart';

class NotFoundNavigationWidget extends StatelessWidget {
  const NotFoundNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                width: AppConstants.spacingXXL,
                image: AssetImage(ImageConstants.instance.error),
              ),
              Text(
                'Aradığınız sayfa bulunamıyor',
                style: context.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
