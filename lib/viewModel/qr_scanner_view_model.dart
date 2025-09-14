import 'package:mobile_scanner/mobile_scanner.dart';

import '../core/base/view_model/base_view_model.dart';

class QrScannerViewModel extends BaseViewModel {
  MobileScannerController? _cameraController;
  bool _isScanned = false;
  String? _scannedValue;

  MobileScannerController? get cameraController => _cameraController;
  bool get isScanned => _isScanned;
  String? get scannedValue => _scannedValue;

  @override
  void init() {
    _cameraController = MobileScannerController();
  }

  @override
  void disp() {
    _cameraController?.dispose();
  }

  void toggleTorch() {
    _cameraController?.toggleTorch();
  }

  void switchCamera() {
    _cameraController?.switchCamera();
  }

  void onQrDetected(String value) {
    if (!_isScanned) {
      _isScanned = true;
      _scannedValue = value;
      notifyListeners();
    }
  }

  void resetScanner() {
    _isScanned = false;
    _scannedValue = null;
    notifyListeners();
  }
}
