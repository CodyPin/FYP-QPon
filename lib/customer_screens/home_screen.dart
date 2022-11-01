import 'package:flutter/material.dart';
import '../qrcode_screen.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final username = client.authStore.model.profile.getStringValue('name');

    return Scaffold(
      body: Text(
        "Welcome $username",
        style: TextStyle(
          color: Colors.green[900],
          fontSize: 45,
          fontWeight: FontWeight.w500,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRCodeScreen(
                title: 'Your Account QRCode',
                qrcode: client.authStore.model.profile.getStringValue('id'),
              ),
            ),
          );
        },
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}
