import 'package:flutter/material.dart';

import '../core/init/theme/app_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';

import '../core/base/base_singleton.dart';
import '../core/constants/image_constants.dart';
import '../core/init/theme/theme_extensions.dart';
import '../models/holidays_model.dart';

class PermissionCard extends StatelessWidget with BaseSingleton {
  final HolidayDataModel item;
  const PermissionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: context.colorScheme.onError,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppConstants.spacingXS),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Builder(
                    builder: (context) {
                      final iconPath = _getIconPath(item.type?.iconName);
                      return SvgPicture.asset(
                        iconPath,
                        width: 36,
                        height: 36,
                        placeholderBuilder: (context) {
                          return Icon(
                            Icons.category,
                            color: context.colorScheme.primary,
                            size: 24,
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: AppConstants.spacingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.type?.title ?? strCons.unSpecified,
                        style: context.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppConstants.spacingXS / 2),
                      _buildStatusChip(
                        context,
                        item.status ?? 0,
                        item.statusText ?? strCons.unSpecified,
                      ),
                    ],
                  ),
                ),
                _buildStatusIcon(context, item.status ?? 0),
              ],
            ),
            SizedBox(height: AppConstants.spacingMD),
            Container(
              padding: EdgeInsets.all(AppConstants.spacingXS),
              decoration: BoxDecoration(
                color: context.colorScheme.onTertiaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDateItem(
                    context,
                    strCons.begining,
                    item.startDate ?? strCons.unSpecified,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: context.colorScheme.onTertiary,
                  ),
                  _buildDateItem(
                    context,
                    strCons.finish,
                    item.endDate ?? strCons.unSpecified,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppConstants.spacingMD),
            if (item.note?.isNotEmpty == true) ...[
              Text(
                strCons.description,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onTertiary,
                ),
              ),
              SizedBox(height: AppConstants.spacingXS),
              Container(
                padding: EdgeInsets.all(AppConstants.spacingXS),
                decoration: BoxDecoration(
                  color: context.colorScheme.onTertiaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.note ?? '',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.onTertiary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getIconPath(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return ImageConstants.instance.administrative;
    }
    if (iconName.startsWith('assets/images/svg/')) {
      return iconName;
    }
    final fullPath = ImageConstants.instance.toSVG(iconName);
    return fullPath;
  }

  Widget _buildStatusChip(BuildContext context, int status, String statusText) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 0:
        backgroundColor = context.colorScheme.onTertiaryContainer;
        textColor = context.colorScheme.onTertiary;
        break;
      case 1:
        backgroundColor = context.colorScheme.primary.withValues(alpha: 0.1);
        textColor = context.colorScheme.primary;
        break;
      case 2:
        backgroundColor = context.colorScheme.error.withValues(alpha: 0.1);
        textColor = context.colorScheme.error;
        break;
      default:
        backgroundColor = context.colorScheme.onTertiaryContainer;
        textColor = context.colorScheme.onTertiary;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMD,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: context.textTheme.bodySmall!.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context, int status) {
    IconData icon;
    Color color;

    switch (status) {
      case 0:
        icon = Icons.hourglass_empty;
        color = context.colorScheme.onTertiary;
        break;
      case 1:
        icon = Icons.check_circle;
        color = context.colorScheme.primary;
        break;
      case 2:
        icon = Icons.cancel;
        color = context.colorScheme.error;
        break;
      default:
        icon = Icons.help_outline;
        color = context.colorScheme.onTertiary;
    }

    return Icon(icon, color: color, size: 28);
  }

  Widget _buildDateItem(BuildContext context, String label, String date) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall!.copyWith(
              color: context.colorScheme.onTertiary,
            ),
          ),
          SizedBox(height: AppConstants.spacingXS / 2),
          Text(
            _formatDate(date),
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onTertiary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      return Jiffy.parse(date).format(pattern: 'dd.MM.yyyy');
    } catch (e) {
      return date;
    }
  }
}
