import 'package:flutter/material.dart';
import 'main.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (client.authStore.isValid)
            ElevatedButton.icon(
              onPressed: () async {
                preLoginPagesIndex = 0;
                storePagesIndex = 0;
                customerPagesIndex = 0;
                client.authStore.clear();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Sign Out'),
            ),
        ],
      ),
    );
  }
}
