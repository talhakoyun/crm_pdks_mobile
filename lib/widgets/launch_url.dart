import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/init/theme/theme_extensions.dart';

import '../core/constants/string_constants.dart';

class UrlLaunch {
  static openUrl(BuildContext context, String link) async {
    return showDialog<void>(
      useSafeArea: true,
      context: context,
      barrierDismissible: true,
      barrierColor: context.colorScheme.primary.withValues(alpha: .5),
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  StringConstants.instance.nonAppRedirect,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  link,
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                Text(StringConstants.instance.enterTheAdress),
                const SizedBox(height: 5),
                Divider(
                  thickness: 1,
                  color: context.colorScheme.primary.withValues(alpha: .5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        _launchURL(link);
                      },
                      textColor: context.colorScheme.onError,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      color: context.colorScheme.tertiary,
                      child: Text('Git', style: context.textTheme.bodyLarge),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      textColor: context.colorScheme.onError,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      color: context.colorScheme.error,
                      child: Text('Vazgeç', style: context.textTheme.bodyLarge),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static _launchURL(String url) async {
    String urls;
    if (!url.contains('http')) {
      urls = "https://$url";
    } else {
      urls = url;
    }

    if (!await launchUrl(Uri.parse(urls))) {
      throw 'Could not launch $url';
    }
  }
}
