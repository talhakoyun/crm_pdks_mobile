import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../core/constants/size_config.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';

class InAndOutsPointsCard extends StatelessWidget {
  final String? startDate, endDate, dateTime;
  const InAndOutsPointsCard({
    super.key,
    this.startDate,
    this.endDate,
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.instance.widthSize(context, 330),
      height: SizeConfig.instance.heightSize(context, 120),
      child: Card(
        elevation: 0,
        color: context.colorScheme.onError,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringConstants.instance.checkInTime,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.surface,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Transform.rotate(
                  angle: -math.pi / -4,
                  child: Icon(
                    Icons.arrow_right_alt,
                    color: context.colorScheme.tertiaryContainer,
                  ),
                ),
                Text(
                  startDate ?? '--',
                  style: context.textTheme.headlineSmall!.copyWith(
                    color: context.colorScheme.tertiaryContainer,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringConstants.instance.dateText,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.surface,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: dateTime != null && dateTime!.isNotEmpty
                        ? Jiffy.parse(dateTime!).format(pattern: 'dd\nMMM ')
                        : '--\n--',
                    style: context.textTheme.headlineSmall!.copyWith(
                      color: context.colorScheme.surface,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringConstants.instance.checkOutTime,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.surface,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Transform.rotate(
                  angle: -math.pi / 4,
                  child: Icon(
                    Icons.arrow_right_alt,
                    color: context.colorScheme.error,
                  ),
                ),
                Text(
                  endDate ?? '--',
                  style: context.textTheme.headlineSmall!.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextArea(BuildContext context, String title, String description) {
    return Expanded(
      flex: 4,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$title\n',
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(
              text: description,
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
