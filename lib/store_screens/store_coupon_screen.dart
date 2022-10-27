import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/src/dtos/record_model.dart';

class StoreCouponScreen extends StatelessWidget {
  const StoreCouponScreen({Key? key, required this.coupon, required this.image}) : super(key: key);

  final RecordModel coupon;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Coupon Details", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
            Hero(tag: coupon.id, child: image),
            Text("Coupon Name: ${coupon.getStringValue('name')}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            Text("Coupon Description: ${coupon.getStringValue('description')}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            Text("Coupon Type: ${coupon.getStringValue('discount_type')}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            Text("Coupon Value: ${coupon.getStringValue('amount')}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            Text("Coupon Expiration Date: ${coupon.getStringValue('expire_date')}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            Text("Coupon Is Active?: ${coupon.getStringValue('is_active')}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
          ],
        ),
    );
  }
}