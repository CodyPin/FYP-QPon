import 'package:flutter/material.dart';
import 'package:qpon/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            client.authStore.clear();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
          ),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Sign Out'),
        ),
      ],
    );
  }
}
