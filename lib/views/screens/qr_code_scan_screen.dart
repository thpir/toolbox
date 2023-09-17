import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanScreen extends StatefulWidget {
  static const routeName = '/qr-code-scan-screen';
  const QRCodeScanScreen({super.key});

  @override
  State<QRCodeScanScreen> createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen> {
  MobileScannerController cameraController = MobileScannerController();

  bool _isPaused = false;

  void _handleDetect(List<Barcode> barcodes) {
    if (_isPaused) {
      return;
    }
    if (barcodes.isNotEmpty) {
      final Barcode firstBarcode = barcodes.first;
      //debugPrint('Barcode found! ${firstBarcode.rawValue}');
      setState(() {
        _isPaused = true;
      });
      cameraController.dispose();
      Navigator.popAndPushNamed(context, '/qr-code-result-screen',
              arguments: firstBarcode.rawValue)
          .then((_) => setState(() {
                _isPaused = false;
              }));
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'appbar_scan_text'.i18n(),
          style: const TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return Icon(Icons.flash_off,
                        color: Theme.of(context).focusColor);
                  case TorchState.on:
                    return Icon(Icons.flash_on,
                        color: Theme.of(context).focusColor);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return Icon(Icons.camera_front,
                        color: Theme.of(context).focusColor);
                  case CameraFacing.back:
                    return Icon(Icons.camera_rear,
                        color: Theme.of(context).focusColor);
                }
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          _handleDetect(barcodes);
        },
      ),
    );
  }
}
