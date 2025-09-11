import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../core/base/size_singleton.dart';
import '../core/constants/string_constants.dart';
import '../core/enums/enums.dart';
import '../core/extension/context_extension.dart';
import '../viewModel/auth_view_model.dart';
import '../viewModel/inandout_list_view_model.dart';

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
    InAndOutListViewModel listVM = Provider.of<InAndOutListViewModel>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.colorScheme.onError,
        // appBar: AppBar(
        //   title: Text(
        //     StringConstants.instance.inAndOutTitle,
        //     style: context.textTheme.headlineSmall!.copyWith(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   centerTitle: true,
        //   automaticallyImplyLeading: false,
        //   backgroundColor: context.colorScheme.onError,
        //   elevation: 0,
        //   actions: [
        //     if (listVM.shiftStatus == ShiftStatus.loaded)
        //       IconButton(
        //         icon: const Icon(Icons.refresh),
        //         onPressed: () {
        //           listVM.fetchShiftList(context);
        //         },
        //       ),
        //   ],
        // ),
        body: SafeArea(child: _buildBody(context, listVM)),
      ),
    );
  }

  Widget _buildBody(BuildContext context, InAndOutListViewModel listVM) {
    switch (listVM.shiftStatus) {
      case ShiftStatus.loaded:
        return _buildLoadedContent(context, listVM);
      case ShiftStatus.loadingFailed:
        return _buildErrorContent(context, listVM);
      default:
        return _buildLoadingContent(context);
    }
  }

  Widget _buildLoadedContent(
    BuildContext context,
    InAndOutListViewModel listVM,
  ) {
    if (listVM.shiftListItems.isEmpty) {
      return _buildEmptyContent(context, listVM);
    }

    return RefreshIndicator(
      backgroundColor: context.colorScheme.onError,
      onRefresh: () async {
        await listVM.fetchShiftList(context);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.onTertiary.withValues(alpha: .2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  StringConstants.instance.totalRecord,
                  '${listVM.shiftListItems.length}',
                  Icons.calendar_today,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: context.colorScheme.outline..withValues(alpha: 0.3),
                ),
                _buildStatItem(
                  context,
                  StringConstants.instance.thisMonth,
                  '${listVM.shiftListItems.length}',
                  Icons.access_time,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: listVM.shiftListItems.length,
              itemBuilder: (context, index) {
                final item = listVM.shiftListItems[index];
                return _buildAttendanceCard(context, item, index);
              },
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
        Text(title, style: context.primaryTextTheme.bodySmall!),
        Text(value, style: context.primaryTextTheme.headlineSmall!),
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
                    Colors.green,
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
                    style: context.primaryTextTheme.bodySmall!.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                // Çıkış
                Expanded(
                  child: _buildTimeInfo(
                    context,
                    StringConstants.instance.exitTime,
                    item.endTime?.isNotEmpty == true ? item.endTime! : '--:--',
                    Icons.logout,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(
    BuildContext context,
    String label,
    String time,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: context.textTheme.bodySmall!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: context.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyContent(
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
              Icons.access_time_outlined,
              size: 80,
              color: context.colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              StringConstants.instance.recordNotFound,
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              StringConstants.instance.noInAndOutText,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            Text(
              StringConstants.instance.unExpectedError,
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                listVM.fetchShiftList(context);
              },
              icon: const Icon(Icons.refresh),
              label: Text(StringConstants.instance.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
