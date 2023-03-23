import 'package:flutter/material.dart';

class CameraErrorScreen extends StatelessWidget {
  const CameraErrorScreen({Key? key, required this.errorText, required this.closeScreen}) : super(key: key);

  final String errorText;
  final Function closeScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            closeScreen();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Text(
          errorText,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
