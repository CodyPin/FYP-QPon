import 'package:flutter/material.dart';
import '../main.dart';

class StoreCouponScreen extends StatefulWidget {
  const StoreCouponScreen({Key? key}) : super(key: key);

  @override
  State<StoreCouponScreen> createState() => _StoreCouponState();
}

class _StoreCouponState extends State<StoreCouponScreen> {
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
