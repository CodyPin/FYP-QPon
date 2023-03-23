// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/src/dtos/record_model.dart';
import 'package:qpon/store_screens/store_coupon_select_screen.dart';
import 'package:qpon/store_screens/use_coupon_screen.dart';
import '../camera_error_screen.dart';
import '../qrcode_screen.dart';
import '../main.dart';

class StoreScanScreen extends StatefulWidget {
  const StoreScanScreen({Key? key}) : super(key: key);

  @override
  State<StoreScanScreen> createState() => _StoreScanScreenState();
}

String storeId = "";
String storeName = "";

class _StoreScanScreenState extends State<StoreScanScreen> {
  Future fetchStoreData() async {
    final response = await client.collection('stores').getList(
        page: 1, perPage: 1, filter: 'owner = "${client.authStore.model.id}"');
    storeId = response.items[0].id;
    storeName = response.items[0].getStringValue('name');
  }

  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    fetchStoreData();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRCodeScreen(
                title: 'Your Account QRCode',
                qrcode: storeId,
              ),
            ),
          );
        },
        child: const Icon(Icons.qr_code),
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
      } on Exception catch (e) {
        try {
          response = await client.collection('user_coupons').getOne(code);
        } on Exception catch (e) {
          HapticFeedback.lightImpact();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CameraErrorScreen(
                    errorText: 'Invalid QR Code, please try again.',
                    closeScreen: closeScreen,
                  ),
            ),
          );
          return;
        }
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UseCouponScreen(
              userID: response.getStringValue('user'),
              username: response.getStringValue('username'),
              closeScreen: closeScreen,
              userCoupon: response,
            ),
          ),
        );
        return;
      }

      if (response.getBoolValue('is_store') == false) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreCouponSelectScreen(
              username: response.getStringValue('username'),
              userID: response.id,
              qrcode: code,
              closeScreen: closeScreen,
            ),
          ),
        );
        return;
      } else {
        HapticFeedback.lightImpact();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraErrorScreen(
              errorText: 'You cannot give another store a coupon!',
              closeScreen: closeScreen,
            ),
          ),
        );
        return;
      }
    }
  }
}
