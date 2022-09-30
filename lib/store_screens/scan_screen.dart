import 'package:flutter/material.dart';
import '../main.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    final username = client.authStore.model.profile.getStringValue('name');

    return Center(
      child: Text(
        "Welcome $username",
        style: TextStyle(
          color: Colors.green[900],
          fontSize: 45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
