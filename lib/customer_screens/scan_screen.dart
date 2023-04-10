import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qpon/camera_error_screen.dart';
import 'coupon_select_screen.dart';
import '../main.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () {
              cameraController.toggleTorch();
            },
          ),
          IconButton(
            onPressed: () => cameraController.switchCamera(),
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
          ),
        ],
      ),
      body: MobileScanner(
        allowDuplicates: true,
        controller: cameraController,
        onDetect: _foundQRCode,
      ),
    );
  }

  void _foundQRCode(Barcode barcode, MobileScannerArguments? args) async {
    void closeScreen() {
      _screenOpened = false;
    }

    if (!_screenOpened) {
      _screenOpened = true;
      final String code = barcode.rawValue ?? "---";

      RecordModel response;

      try {
        response = await client.collection('users').getOne(code);
      } catch (e) {
        HapticFeedback.lightImpact();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraErrorScreen(
              errorText: 'Invalid QR Code, please try again.',
              closeScreen: closeScreen,
            ),
          ),
        );
        return;
      }

      if (response.getBoolValue('is_store') == false) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CouponSelectScreen(
              username: response.getStringValue('username'),
              qrcode: code,
              closeScreen: closeScreen,
            ),
          ),
        );
      } else {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraErrorScreen(
              errorText: 'Invalid QR Code, please try again.',
              closeScreen: closeScreen,
            ),
          ),
        );
      }
    }
  }
}
