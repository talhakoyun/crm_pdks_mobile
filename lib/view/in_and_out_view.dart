import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/size_singleton.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';
import '../core/init/size/size_setting.dart';
import '../viewModel/auth_view_model.dart';
import '../viewModel/inandout_list_view_model.dart';
import '../widgets/error_widget.dart';
import '../widgets/in_and_out_points_card.dart';
import '../core/enums/enums.dart';

class InAndOutsView extends StatefulWidget {
  const InAndOutsView({super.key});

  @override
  State<InAndOutsView> createState() => _InAndOutsViewState();
}

class _InAndOutsViewState extends State<InAndOutsView> with SizeSingleton {
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
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
