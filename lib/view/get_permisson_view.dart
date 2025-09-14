import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

<<<<<<< Updated upstream
import '../core/base/size_singleton.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
=======
import '../core/constants/string_constants.dart';
import '../core/init/theme/theme_extensions.dart';
>>>>>>> Stashed changes
import '../viewModel/permissions_view_model.dart';
import '../widgets/button/perm_button.dart';
import '../widgets/text_input/get_permission_text_input.dart';

class GetPermissionView extends StatefulWidget {
  const GetPermissionView({super.key});

  @override
  State<GetPermissionView> createState() => _GetPermissionViewState();
}

class _GetPermissionViewState extends State<GetPermissionView>
<<<<<<< Updated upstream
    with SizeSingleton {
=======
    with TickerProviderStateMixin {
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
      backgroundColor: context.colorScheme.onTertiaryContainer,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildBody(context, permissionVM),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    PermissionViewModel permissionVM,
  ) {
    return SliverAppBar(
      expandedHeight: 175.0,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: context.colorScheme.primary,
      title: Text(
        "İzin Talebi",
        style: Theme.of(context).primaryTextTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.bold,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onError.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.assignment_ind_outlined,
                      size: 45,
                      color: context.colorScheme.onError,
                    ),
                  ),
                  Text(
                    "Lütfen izin bilgilerinizi eksiksiz doldurun",
                    style: Theme.of(context).primaryTextTheme.bodyMedium!
                        .copyWith(
                          color: context.colorScheme.onError.withValues(
                            alpha: 0.9,
                          ),
                          fontSize: 11,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () => _handleBack(context, permissionVM),
        style: IconButton.styleFrom(
          backgroundColor: context.colorScheme.onError.withValues(alpha: 0.9),
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: context.colorScheme.primary,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PermissionViewModel permissionVM) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, permissionVM),
          SliverToBoxAdapter(child: _buildFormSection(context, permissionVM)),
        ],
      ),
    );
  }

  Widget _buildFormSection(
    BuildContext context,
    PermissionViewModel permissionVM,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onError,

        boxShadow: [
          BoxShadow(
            color: context.colorScheme.errorContainer.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("İzin Türü", Icons.category_outlined),
            context.gapXS,
            _buildModernHolidayType(permissionVM),
            context.gapLG,
            _buildSectionTitle("Tarih Aralığı", Icons.date_range_outlined),
            context.gapXS,
            _buildDateRangeSection(permissionVM),
            context.gapLG,
            _buildSectionTitle("Açıklama", Icons.description_outlined),
            context.gapXS,
            _buildModernPermissionReason(permissionVM),
            context.gapLG,
            _buildSectionTitle("İletişim Adresi", Icons.location_on_outlined),
            context.gapXS,
            _buildModernPermissionAddress(permissionVM),
            context.gapLG,
            _buildModernSendButton(context, permissionVM),
            context.gapMD,
>>>>>>> Stashed changes
          ],
        ),
      ),
    );
  }

<<<<<<< Updated upstream
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
=======
  // Helper Methods
  void _handleBack(BuildContext context, PermissionViewModel permissionVM) {
    permissionVM.holidayAddress.clear();
    permissionVM.holidayReason.clear();
    permissionVM.holidayEndDt.clear();
    permissionVM.holidayStartDt.clear();
    permissionVM.holidayType.clear();
    Navigator.of(context).pop();
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
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
=======
  Widget _buildModernHolidayType(PermissionViewModel permissionVM) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.surface.withValues(alpha: 0.3),
        ),
        color: context.colorScheme.surfaceContainerHighest,
      ),
      child: InkWell(
        onTap: permissionVM.typeItems.isNotEmpty
            ? () => _showTypePicker(context, permissionVM)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.category_outlined,
                  size: 20,
                  color: context.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "İzin Türü",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.outline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      permissionVM.holidayType.text.isEmpty
                          ? (permissionVM.typeItems.isEmpty
                                ? 'Yükleniyor...'
                                : 'İzin türünü seçin')
                          : permissionVM.holidayType.text,
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: permissionVM.holidayType.text.isEmpty
                            ? context.colorScheme.outline
                            : context.colorScheme.onTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (permissionVM.typeItems.isEmpty)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.keyboard_arrow_down,
                  color: context.colorScheme.primary,
                ),
            ],
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
=======
  Widget _buildDateRangeSection(PermissionViewModel permissionVM) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.surface.withValues(alpha: 0.3),
        ),
        color: context.colorScheme.surfaceContainerHighest,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildDateField(
                    label: "Başlangıç",
                    value: permissionVM.holidayStartDt.text,
                    icon: Icons.play_arrow,
                    onTap: () => _showStartDatePicker(context, permissionVM),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: context.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: _buildDateField(
                    label: "Bitiş",
                    value: permissionVM.holidayEndDt.text,
                    icon: Icons.stop,
                    onTap: () => _showEndDatePicker(context, permissionVM),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorScheme.surface.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: context.colorScheme.primary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value.isEmpty ? 'Tarih seçin' : value,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: value.isEmpty
                    ? context.colorScheme.outline
                    : context.colorScheme.onTertiary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernPermissionReason(PermissionViewModel permissionVM) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.surface.withValues(alpha: 0.3),
        ),
        color: context.colorScheme.surfaceContainerHighest,
      ),
      child: TextField(
        controller: permissionVM.holidayReason,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'İzin sebebinizi detaylı bir şekilde açıklayın...',
          hintStyle: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.outline,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              Icons.description_outlined,
              color: context.colorScheme.primary,
            ),
          ),
        ),
        style: context.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildModernPermissionAddress(PermissionViewModel permissionVM) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.surface.withValues(alpha: 0.3),
        ),
        color: context.colorScheme.surfaceContainerHighest,
      ),
      child: TextField(
        controller: permissionVM.holidayAddress,
        maxLines: 3,
        decoration: InputDecoration(
          hintText:
              'İzin süresince ulaşılabileceğiniz adres bilgilerini girin...',
          hintStyle: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.outline,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              Icons.location_on_outlined,
              color: context.colorScheme.primary,
            ),
          ),
        ),
        style: context.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildModernSendButton(
    BuildContext context,
    PermissionViewModel permissionVM,
  ) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          permissionVM.getPermission(
            type: type,
            startDt: startDt,
            endDt: endDt,
            context: context,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_rounded,
              color: context.colorScheme.onSurface,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              StringConstants.instance.send,
              style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Picker Methods
>>>>>>> Stashed changes
  void _showTypePicker(BuildContext ctx, PermissionViewModel permissionVM) {
    if (permissionVM.typeItems.isEmpty) {
      permissionVM.fetchHolidayTypes();
      return;
    }

    showCupertinoModalPopup(
      context: ctx,
<<<<<<< Updated upstream
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
=======
      builder: (_) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
>>>>>>> Stashed changes
                  Text(
                    type.title ?? '',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
<<<<<<< Updated upstream
              ],
              onSelectedItemChanged: (int index) {
                final selectedType = permissionVM.typeItems[index];
                permissionVM.holidayType.text = selectedType.title ?? '';
                type = selectedType.id ?? 0;
              },
            ),
          ),
        ],
=======
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: Icon(Icons.close, color: context.colorScheme.outline),
                  ),
                ],
              ),
            ),
            // Picker
            Expanded(
              child: CupertinoPicker(
                backgroundColor: context.colorScheme.surface,
                itemExtent: 50,
                scrollController: FixedExtentScrollController(initialItem: 0),
                children: [
                  for (var typeItem in permissionVM.typeItems)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.assignment_outlined,
                              size: 20,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              typeItem.title ?? '',
                              style: context.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
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
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
      builder: (_) => Container(
        height: 350,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Başlangıç Tarihi",
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: Icon(Icons.close, color: context.colorScheme.outline),
                  ),
                ],
              ),
            ),
            // Date Picker
            Expanded(
              child: CupertinoDatePicker(
                minimumDate: DateTime.now(),
                backgroundColor: context.colorScheme.surface,
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
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
      builder: (_) => Container(
        height: 350,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bitiş Tarihi",
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: Icon(Icons.close, color: context.colorScheme.outline),
                  ),
                ],
              ),
            ),
            // Date Picker
            Expanded(
              child: CupertinoDatePicker(
                minimumDate: minimumDate,
                backgroundColor: context.colorScheme.surface,
                use24hFormat: true,
                initialDateTime: minimumDate,
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
>>>>>>> Stashed changes
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
