import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qpon/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
