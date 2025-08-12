import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../core/base/size_singleton.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
import '../viewModel/permissions_view_model.dart';
import '../widgets/button/perm_button.dart';
import '../widgets/text_input/get_permission_text_input.dart';

class GetPermissionView extends StatefulWidget {
  const GetPermissionView({super.key});

  @override
  State<GetPermissionView> createState() => _GetPermissionViewState();
}

class _GetPermissionViewState extends State<GetPermissionView>
    with SizeSingleton {
  DateTime startDt = DateTime.now();
  DateTime endDt = DateTime.now();
  int type = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final permissionVM = Provider.of<PermissionViewModel>(
        context,
        listen: false,
      );
      permissionVM.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    PermissionViewModel permissionVM = Provider.of<PermissionViewModel>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          StringConstants.instance.getLeavePermissionText,
          style: context.textTheme.headlineMedium!.copyWith(
            color: context.colorScheme.onTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            permissionVM.holidayAddress.clear();
            permissionVM.holidayReason.clear();
            permissionVM.holidayEndDt.clear();
            permissionVM.holidayStartDt.clear();
            permissionVM.holidayType.clear();
            context.navigationOf.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: context.colorScheme.onTertiary,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 15.scalablePixel,
            right: 15.scalablePixel,
          ),
          children: [
            Image.asset(
              ImageConstants.instance.getPerm,
              height: sizeConfig.heightSize(context, 180),
            ),
            context.emptySizedHeightBoxLow2x,
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                StringConstants.instance.leaveText,
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            context.emptySizedHeightBoxLow,
            _holidayType(permissionVM),
            context.emptySizedHeightBoxLow2x,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _holidayStartDate(permissionVM),
                context.emptySizedWidthBoxLow3x,
                _holidayEndDate(permissionVM),
              ],
            ),
            context.emptySizedHeightBoxLow,
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                StringConstants.instance.description,
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: context.colorScheme.surface,
                ),
              ),
            ),
            context.emptySizedHeightBoxLow,
            permissionReason(permissionVM),
            context.emptySizedHeightBoxLow2x,
            permissonAddress(permissionVM),
            context.emptySizedHeightBoxLow2x,
            _sendBtn(context, permissionVM),
          ],
        ),
      ),
    );
  }

  Widget _holidayType(PermissionViewModel permissionVM) {
    return GetPermissionInput(
      obscureText: false,
      controller: permissionVM.holidayType,
      prefixIcon: Icon(
        Icons.touch_app,
        size: 20.scalablePixel,
        color: context.colorScheme.onTertiary,
      ),
      constraints: BoxConstraints(
        maxHeight: sizeConfig.heightSize(context, 55),
        maxWidth: sizeConfig.widthSize(context, 300),
      ),
      hintText: permissionVM.typeItems.isEmpty
          ? 'Yükleniyor...'
          : StringConstants.instance.choose,
      maxLines: 1,
      minLines: 1,
      readOnly: true,
      suffixIcon: permissionVM.typeItems.isEmpty
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.keyboard_arrow_down, color: context.colorScheme.surface),
      showCursor: false,
      textInputType: TextInputType.text,
      onTap: permissionVM.typeItems.isNotEmpty
          ? () => _showTypePicker(context, permissionVM)
          : null,
    );
  }

  Widget _holidayStartDate(PermissionViewModel permissionVM) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            StringConstants.instance.begining,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w400,
              color: context.colorScheme.surface,
            ),
          ),
        ),
        context.emptySizedHeightBoxLow,
        GetPermissionInput(
          prefixIcon: Icon(
            Icons.calendar_month,
            size: 20.scalablePixel,
            color: context.colorScheme.onTertiary,
          ),
          constraints: BoxConstraints(
            maxHeight: sizeConfig.heightSize(context, 55),
            maxWidth: sizeConfig.widthSize(context, 155),
          ),
          obscureText: false,
          controller: permissionVM.holidayStartDt,
          hintText: StringConstants.instance.choose,
          textStyle: context.primaryTextTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ),
          maxLines: 1,
          minLines: 1,
          readOnly: true,
          showCursor: false,
          textInputType: TextInputType.text,
          onTap: () => _showStartDatePicker(context, permissionVM),
        ),
      ],
    );
  }

  Widget _holidayEndDate(PermissionViewModel permissionVM) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            StringConstants.instance.finish,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w400,
              color: context.colorScheme.surface,
            ),
          ),
        ),
        context.emptySizedHeightBoxLow,
        GetPermissionInput(
          prefixIcon: Icon(
            Icons.calendar_month,
            size: 20.scalablePixel,
            color: context.colorScheme.onTertiary,
          ),
          obscureText: false,
          constraints: BoxConstraints(
            maxHeight: sizeConfig.heightSize(context, 55),
            maxWidth: sizeConfig.widthSize(context, 155),
          ),
          controller: permissionVM.holidayEndDt,
          hintText: StringConstants.instance.choose,
          textStyle: context.primaryTextTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ),
          maxLines: 1,
          minLines: 1,
          readOnly: true,
          showCursor: false,
          textInputType: TextInputType.text,
          onTap: () => _showEndDatePicker(context, permissionVM),
        ),
      ],
    );
  }

  Widget permissionReason(PermissionViewModel permissionVM) {
    return GetPermissionInput(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 4, bottom: 4, right: 4),
        child: SvgPicture.asset(
          alignment: Alignment.center,
          ImageConstants.instance.description,
          colorFilter: ColorFilter.mode(
            context.colorScheme.onTertiary,
            BlendMode.srcIn,
          ),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: sizeConfig.heightSize(context, 55),
        maxWidth: sizeConfig.widthSize(context, 300),
      ),
      obscureText: false,
      controller: permissionVM.holidayReason,
      hintText: StringConstants.instance.leaveReasonText,
      maxLines: 1,
      minLines: 1,
      readOnly: false,
      showCursor: true,
      textInputType: TextInputType.text,
    );
  }

  Widget permissonAddress(PermissionViewModel permissionVM) {
    return GetPermissionInput(
      prefixIcon: Icon(
        Icons.location_on_rounded,
        color: context.colorScheme.onTertiary,
      ),
      constraints: BoxConstraints(
        maxHeight: sizeConfig.heightSize(context, 100),
        maxWidth: sizeConfig.widthSize(context, 300),
      ),
      obscureText: false,
      controller: permissionVM.holidayAddress,
      hintText: StringConstants.instance.moveAddressText,
      minLines: 2,
      maxLines: 3,
      readOnly: false,
      showCursor: true,
      textInputType: TextInputType.text,
    );
  }

  Widget _sendBtn(BuildContext context, PermissionViewModel permissionVM) {
    return Padding(
      padding: const EdgeInsets.only(left: 55, right: 55),
      child: SizedBox(
        height: sizeConfig.heightSize(context, 55),
        child: PermButton(
          onTap: () {
            permissionVM.getPermission(
              type: type,
              startDt: startDt,
              endDt: endDt,
              context: context,
            );
          },
          buttonTex: StringConstants.instance.send,
          buttonColor: context.colorScheme.onSecondary,
        ),
      ),
    );
  }

  void _showTypePicker(BuildContext ctx, PermissionViewModel permissionVM) {
    if (permissionVM.typeItems.isEmpty) {
      permissionVM.fetchHolidayTypes();
      return;
    }

    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: SizerUtil.height * .2,
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              itemExtent: 30,
              scrollController: FixedExtentScrollController(initialItem: 0),
              children: [
                for (var type in permissionVM.typeItems)
                  Text(
                    type.title ?? '',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
              ],
              onSelectedItemChanged: (int index) {
                final selectedType = permissionVM.typeItems[index];
                permissionVM.holidayType.text = selectedType.title ?? '';
                type = selectedType.id ?? 0;
              },
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      if (type == 0 && permissionVM.typeItems.isNotEmpty) {
        final firstType = permissionVM.typeItems.first;
        type = firstType.id ?? 0;
        permissionVM.holidayType.text = firstType.title ?? '';
      }
    });
  }

  void _showStartDatePicker(ctx, PermissionViewModel permissionVM) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: SizerUtil.height * .2,
            child: CupertinoDatePicker(
              minimumDate: DateTime.now(),
              backgroundColor: Colors.white,
              use24hFormat: true,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (val) {
                endDt = DateTime(1890);
                permissionVM.holidayEndDt.text = "";
                startDt = val;
                permissionVM.holidayStartDt.text = Jiffy.parseFromDateTime(
                  startDt,
                ).format(pattern: 'dd.MM.yyyy, HH:mm');
              },
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      if (permissionVM.holidayStartDt.text.isEmpty) {
        permissionVM.holidayStartDt.text = Jiffy.parseFromDateTime(
          DateTime.now(),
        ).format(pattern: 'dd.MM.yyyy, HH:mm');
      }
    });
  }

  void _showEndDatePicker(ctx, PermissionViewModel permissionVM) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: SizerUtil.height * .2,
            child: CupertinoDatePicker(
              minimumDate: DateTime.now(),
              backgroundColor: Colors.white,
              use24hFormat: true,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (val) {
                endDt = val;

                permissionVM.holidayEndDt.text = Jiffy.parseFromDateTime(
                  endDt,
                ).format(pattern: 'dd.MM.yyyy, HH:mm');
              },
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      if (permissionVM.holidayEndDt.text.isEmpty) {
        permissionVM.holidayEndDt.text = Jiffy.parseFromDateTime(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day + 1,
          ),
        ).format(pattern: 'dd.MM.yyyy, HH:mm');
      }
    });
  }
}
