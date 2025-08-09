import 'package:flutter/material.dart';

import '../constants/image_constants.dart';
import '../extension/context_extension.dart';
import '../init/size/size_extension.dart';

class NotFoundNavigationWidget extends StatelessWidget {
  const NotFoundNavigationWidget({Key? key}) : super(key: key);

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
                width: 70.width,
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
