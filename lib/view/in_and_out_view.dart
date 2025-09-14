import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

<<<<<<< Updated upstream
import '../core/base/size_singleton.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/enums/enums.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
=======
import '../core/constants/string_constants.dart';
import '../core/enums/enums.dart';
import '../core/init/theme/theme_extensions.dart';
>>>>>>> Stashed changes
import '../viewModel/auth_view_model.dart';
import '../viewModel/inandout_list_view_model.dart';
import '../widgets/error_widget.dart';
import '../widgets/in_and_out_points_card.dart';

class InAndOutsView extends StatefulWidget {
  const InAndOutsView({super.key});

  @override
  State<InAndOutsView> createState() => _InAndOutsViewState();
}

class _InAndOutsViewState extends State<InAndOutsView> {
  AuthViewModel authVM = AuthViewModel();
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final listVM = Provider.of<InAndOutListViewModel>(context, listen: false);
      listVM.fetchShiftList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // authVM = context.watch<AuthViewModel>();
    InAndOutListViewModel listVM = Provider.of<InAndOutListViewModel>(context);

    return listVM.shiftStatus == ShiftStatus.loaded
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  context.navigationOf.pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
<<<<<<< Updated upstream
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: SizerUtil.height,
                    minWidth: SizerUtil.width,
                  ),
                  child: Column(
                    children: [
                      buildTopArea(context, authVM),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: 2.75,
                          child: Text(
                            StringConstants.instance.monthlyData,
                            style: context.textTheme.headlineSmall!.copyWith(
                              color: context.colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: SizerUtil.height > 535 ? 7 : 5,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                              bottom: 15.0,
                            ),
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                listVM.shiftListItems.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: listVM.shiftListItems.length,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                              return InAndOutsPointsCard(
                                                startDate:
                                                    listVM
                                                        .shiftListItems[index]
                                                        .startTime!
                                                        .isNotEmpty
                                                    ? listVM
                                                          .shiftListItems[index]
                                                          .startTime
                                                    : "--",
                                                dateTime:
                                                    listVM
                                                        .shiftListItems[index]
                                                        .datetime!
                                                        .isNotEmpty
                                                    ? listVM
                                                          .shiftListItems[index]
                                                          .datetime
                                                    : "--",
                                                endDate:
                                                    listVM
                                                        .shiftListItems[index]
                                                        .endTime!
                                                        .isNotEmpty
                                                    ? listVM
                                                          .shiftListItems[index]
                                                          .endTime
                                                    : "--",
                                              );
                                            },
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                          top: 20.0.height,
                                        ),
                                        child: Center(
                                          child: Text(
                                            StringConstants
                                                .instance
                                                .noInAndOutText,
                                            style: context.textTheme.bodyLarge!
                                                .copyWith(
                                                  color:
                                                      context.colorScheme.error,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : listVM.shiftStatus == ShiftStatus.loadingFailed
        ? errorPageView(
            context: context,
            imagePath: ImageConstants.instance.warning,
            title: StringConstants.instance.unExpectedError,
            subtitle: ' ',
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: context.colorScheme.primary,
                valueColor: AlwaysStoppedAnimation(
                  context.colorScheme.onPrimary,
                ),
                color: context.colorScheme.error,
              ),
            ),
          );
  }

  Widget buildTopArea(BuildContext context, AuthViewModel authViewModel) {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (BuildContext context) => authViewModel,
      child: Consumer<AuthViewModel>(
        builder: (context, value, _) {
          return Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SafeArea(
                      child: Column(
                        children: [
                          Image(
                            image: value.gender == 'Erkek'
                                ? AssetImage(ImageConstants.instance.male)
                                : AssetImage(ImageConstants.instance.female),
                            fit: BoxFit.contain,
                            height: sizeConfig.heightSize(context, 80),
                            width: sizeConfig.widthSize(context, 80),
                          ),
                          context.emptySizedHeightBoxLow,
                          Text(
                            value.userName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: context.primaryTextTheme.headlineSmall,
                          ),
                          Text(
                            value.department!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: context.primaryTextTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizerUtil.width,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildTextArea(
                              context,
                              StringConstants.instance.inTime,
                              value.startDate ??
                                  StringConstants.instance.unSpecified,
                            ),
                            buildTextArea(
                              context,
                              StringConstants.instance.shift,
                              value.shiftName!,
                            ),
                            buildTextArea(
                              context,
                              StringConstants.instance.outTime,
                              value.endDate ??
                                  StringConstants.instance.unSpecified,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
=======
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: context.colorScheme.onError, size: 24),
        Text(title, style: Theme.of(context).primaryTextTheme.bodySmall!),
        Text(value, style: Theme.of(context).primaryTextTheme.headlineSmall!),
      ],
    );
  }

  Widget _buildAttendanceCard(BuildContext context, dynamic item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: .2),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onTertiary.withValues(alpha: .05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tarih başlığı
            Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    context,
                    StringConstants.instance.entryTime,
                    item.startTime?.isNotEmpty == true
                        ? item.startTime!
                        : '--:--',
                    Icons.login,
                    context.colorScheme.tertiary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.datetime?.isNotEmpty == true
                        ? Jiffy.parse(
                            item.datetime!,
                          ).format(pattern: 'dd/MM/yyyy')
                        : '--',
                    style: Theme.of(context).primaryTextTheme.bodySmall!
                        .copyWith(color: context.colorScheme.primary),
                  ),
                ),
                // Çıkış
                Expanded(
                  child: _buildTimeInfo(
                    context,
                    StringConstants.instance.exitTime,
                    item.endTime?.isNotEmpty == true ? item.endTime! : '--:--',
                    Icons.logout,
                    context.colorScheme.secondary,
                  ),
                ),
              ],
>>>>>>> Stashed changes
            ),
          );
        },
      ),
    );
  }

  Widget buildTextArea(BuildContext context, String title, String description) {
    return Expanded(
      flex: 4,
      child: Text.rich(
        TextSpan(
          children: [
<<<<<<< Updated upstream
            TextSpan(
              text: '$title\n',
              style: context.primaryTextTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(
              text: description,
              style: context.primaryTextTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
=======
            Icon(
              Icons.access_time_outlined,
              size: 80,
              color: context.colorScheme.outline.withValues(alpha: .5),
            ),
            context.gapLG,
            Text(
              StringConstants.instance.recordNotFound,
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            context.gapSM,
            Text(
              StringConstants.instance.noInAndOutText,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            context.gapLG,
            ElevatedButton.icon(
              onPressed: () {
                listVM.fetchShiftList(context);
              },
              icon: const Icon(Icons.refresh),
              label: Text(StringConstants.instance.refresh),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorContent(
    BuildContext context,
    InAndOutListViewModel listVM,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: context.colorScheme.error,
            ),
            context.gapLG,
            Text(
              StringConstants.instance.unExpectedError,
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            context.gapLG,
            ElevatedButton.icon(
              onPressed: () {
                listVM.fetchShiftList(context);
              },
              icon: const Icon(Icons.refresh),
              label: Text(StringConstants.instance.tryAgain),
            ),
>>>>>>> Stashed changes
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
