import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../core/constants/string_constants.dart';
import '../viewModel/qr_scanner_view_model.dart';

class QrScannerView extends StatelessWidget {
  final Function(String) onQrScanned;

  const QrScannerView({super.key, required this.onQrScanned});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QrScannerViewModel()..init(),
      child: Consumer<QrScannerViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(StringConstants.instance.permissionScanQr),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.flash_on),
                  iconSize: 32.0,
                  onPressed: () => viewModel.toggleTorch(),
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.camera_rear),
                  iconSize: 32.0,
                  onPressed: () => viewModel.switchCamera(),
                ),
              ],
            ),
            body: Stack(
              children: [
                MobileScanner(
                  controller: viewModel.cameraController,
                  onDetect: (capture) {
                    if (!viewModel.isScanned) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          viewModel.onQrDetected(barcode.rawValue!);
                          onQrScanned(barcode.rawValue!);
                          break;
                        }
                      }
                    }
                  },
                ),
                // QR kod çerçevesi
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Alt kısımda açıklama
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      StringConstants.instance.permissionQrFrame,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
