import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../main.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

String storeId = "";
String storeName = "";

class _ScanScreenState extends State<ScanScreen> {
  Future fetchStoreData() async {
    final response = await client.records.getList('stores',
        page: 1,
        perPage: 1,
        filter: 'owner = "${client.authStore.model.profile.id}"');
    storeId = response.items[0].id;
    storeName = response.items[0].getStringValue('name');
  }

  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    final username = client.authStore.model.profile.getStringValue('name');
    fetchStoreData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[100],
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
      )
    );
  }

  void _foundQRCode(Barcode barcode, MobileScannerArguments? args){
    if (!_screenOpened) {
      _screenOpened = true;
      final String code = barcode.rawValue ?? "---";

    }
  }
}
