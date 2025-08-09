import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';

import '../core/base/base_singleton.dart';
import '../core/constants/image_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/theme/color_scheme.dart';

class PermissionListTile extends StatelessWidget with BaseSingleton {
  const PermissionListTile({
    super.key,
    required this.approvalStatus,
    required this.startDate,
    required this.endDate,
    required this.confirmText,
    required this.typeText,
    required this.reasonText,
    required this.address,
    this.type,
  });
  final int approvalStatus;
  final int? type;
  final String startDate, endDate, confirmText, address, typeText, reasonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92.width,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: context.colorScheme.onError,
        child: Padding(
          padding: context.paddingNormal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    (type == 1)
                        ? imgCons.free
                        : (type == 2)
                        ? imgCons.administrative
                        : (type == 3)
                        ? imgCons.annualpermit
                        : (type == 4)
                        ? imgCons.health
                        : (type == 5)
                        ? imgCons.maternity
                        : (type == 6)
                        ? imgCons.breastfeeding
                        : (type == 7)
                        ? imgCons.paternity
                        : (type == 8)
                        ? imgCons.wedding
                        : (type == 9)
                        ? imgCons.death
                        : (type == 10)
                        ? imgCons.birthPerm
                        : imgCons.administrative,
                  ),
                  Padding(
                    padding: context.onlyLeftPaddingLow,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '$typeText\n',
                            style: context.textTheme.headlineSmall!.copyWith(
                              color: context.colorScheme.surface,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: confirmText,
                                style: context.textTheme.bodyLarge!.copyWith(
                                  color: CustomColorScheme.instance!
                                      .determineColor(approvalStatus),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: context.onlyRightPaddingLow,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          (approvalStatus == 0)
                              ? ImageConstants.instance.onHold
                              : (approvalStatus == 1)
                              ? ImageConstants.instance.approved
                              : (approvalStatus == 2)
                              ? ImageConstants.instance.denied
                              : ImageConstants.instance.onHold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: context.paddingLow,
                child: Text.rich(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    text: reasonText,
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onTertiary,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 35.width,
                    height: 5.height,
                    decoration: BoxDecoration(
                      color: context.colorScheme.onTertiaryContainer,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          text: Jiffy.parseFromDateTime(
                            startDate as DateTime,
                          ).format(pattern: 'dd.MM.yyyy, HH:mm'),
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.onTertiary,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: 13.scalablePixel),
                  Container(
                    width: 35.width,
                    height: 5.height,
                    decoration: BoxDecoration(
                      color: context.colorScheme.onTertiaryContainer,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          text: Jiffy.parseFromDateTime(
                            endDate as DateTime,
                          ).format(pattern: 'dd.MM.yyyy, HH:mm'),
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.onTertiary,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              context.emptySizedHeightBoxLow,
              Divider(color: context.colorScheme.onTertiary, thickness: 0.5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_sharp,
                    size: 17.5.scalablePixel,
                    color: context.colorScheme.onTertiaryContainer,
                  ),
                  Expanded(
                    child: Text.rich(
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        text: address,
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: context.colorScheme.onTertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
