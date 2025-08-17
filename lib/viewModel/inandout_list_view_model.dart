// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';

import '../core/base/view_model/base_view_model.dart';
import '../core/extension/context_extension.dart';
import '../models/events_model.dart';
import '../service/in_and_out_service.dart';
import '../widgets/dialog/snackbar.dart';
import '../core/enums/enums.dart';

class InAndOutListViewModel extends BaseViewModel {
  ShiftStatus? shiftStatus;
  List<EventDataModel> shiftListItems = [];
  EventsModel? eventList;
  final inAndOutService = InAndOutService();

  InAndOutListViewModel() {
    shiftStatus = ShiftStatus.loading;
  }

  @override
  void disp() {}

  @override
  void init() {}

  // Deprecated method, use init() instead
  void fetchList(BuildContext context) async {
    await fetchShiftList(context);
  }

  Future<void> fetchShiftList(BuildContext context) async {
    shiftStatus = ShiftStatus.loading;
    notifyListeners();

    try {
      EventsModel shiftListModel = await inAndOutService.shiftList();
      if (shiftListModel.status!) {
        shiftListItems = shiftListModel.data!;
        // Veriler başarıyla yüklendi
        shiftStatus = ShiftStatus.loaded;
      } else {
        shiftStatus = ShiftStatus.loadingFailed;
        CustomSnackBar(
          context,
          shiftListModel.message!,
          backgroundColor: context.colorScheme.error,
        );
      }
    } catch (e) {
      shiftStatus = ShiftStatus.loadingFailed;
      CustomSnackBar(
        context,
        'Veri yüklenirken hata oluştu',
        backgroundColor: context.colorScheme.error,
      );
    }
    notifyListeners();
  }
}
