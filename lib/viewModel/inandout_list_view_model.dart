import 'package:flutter/cupertino.dart';

import '../core/base/view_model/base_view_model.dart';
import '../core/constants/service_locator.dart';
import '../core/enums/enums.dart';
import '../core/extension/context_extension.dart';
import '../models/shift_model.dart';
import '../service/in_and_out_service.dart';
import '../widgets/snackbar.dart';

class InAndOutListViewModel extends BaseViewModel {
  ShiftStatus? shiftStatus;
  List<ShiftDataModel> shiftListItems = [];
  ShiftsModel? shiftList;
  late final InAndOutService _inAndOutService;

  InAndOutListViewModel({InAndOutService? inAndOutService}) : super() {
    _inAndOutService =
        inAndOutService ?? ServiceLocator.instance.get<InAndOutService>();
    shiftStatus = ShiftStatus.loading;
  }

  @override
  void disp() {}

  @override
  void init() {}

  void fetchList(BuildContext context) async {
    await fetchShiftList(context);
  }

  Future<void> fetchShiftList(BuildContext context) async {
    shiftStatus = ShiftStatus.loading;
    notifyListeners();

    try {
      ShiftsModel shiftListModel = await _inAndOutService.shiftList();
      if (shiftListModel.status!) {
        shiftListItems = shiftListModel.data!;
        shiftStatus = ShiftStatus.loaded;
      } else {
        shiftStatus = ShiftStatus.loadingFailed;
        if (!context.mounted) return;
        CustomSnackBar(
          context,
          shiftListModel.message!,
          backgroundColor: context.colorScheme.error,
        );
      }
    } catch (e) {
      shiftStatus = ShiftStatus.loadingFailed;
      if (!context.mounted) return;
      CustomSnackBar(
        context,
        'Veri yüklenirken hata oluştu',
        backgroundColor: context.colorScheme.error,
      );
    }
    notifyListeners();
  }
}
