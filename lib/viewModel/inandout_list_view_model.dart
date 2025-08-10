// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';

import '../core/base/view_model/base_view_model.dart';
import '../core/extension/context_extension.dart';
import '../models/events_model.dart';
import '../service/in_and_out_service.dart';
import '../widgets/dialog/snackbar.dart';

enum ShiftStatus { loading, loaded, loadingFailed }

class InAndOutListViewModel extends BaseViewModel {
  ShiftStatus? shiftStatus;
  List<EventDataModel> shiftListItems = [];
  EventsModel? eventList;
  final inAndOutService = InAndOutService();

  InAndOutListViewModel() {
    shiftStatus = ShiftStatus.loading;
  }
  void fetchList(BuildContext context) async {
    shiftStatus = ShiftStatus.loading;
    EventsModel shiftListModel = await inAndOutService.shiftList();
    if (shiftListModel.status!) {
      shiftListItems = shiftListModel.data!;
      shiftStatus = ShiftStatus.loaded;
      notifyListeners();
    } else {
      shiftStatus = ShiftStatus.loadingFailed;
      CustomSnackBar(
        context,
        shiftListModel.message!,
        backgroundColor: context.colorScheme.error,
      );
      notifyListeners();
    }
  }

  void changeExpanded(index) {
    shiftListItems[index].expanded = !shiftListItems[index].expanded!;
    notifyListeners();
  }

  @override
  void disp() {}

  @override
  void init() {}
}
