import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

import '../qrcode_screen.dart';
import '../utils/color.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({Key? key, required this.coupon, required this.image}) : super(key: key);

  final RecordModel coupon;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Coupon Details",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          Hero(
            tag: coupon.id,
            child: image,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Coupon Name: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      coupon.getStringValue('name'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Coupon Description: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      coupon.getStringValue('description'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Coupon Type: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      coupon.getStringValue('discount_type'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Coupon Value: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      coupon.getStringValue('amount'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Coupon Expiration Date: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd hh:mm').format(
                        DateFormat('yyyy-MM-dd hh:mm:ss.000').parse(
                          coupon.getStringValue('expire_date'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodeScreen(
                    title: 'Your Coupon QRCode',
                    qrcode: coupon.getStringValue('id'),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              foregroundColor: getColor(Colors.white, Colors.black),
              backgroundColor: getColor(Colors.black, Colors.white),
            ),
            child: const Text(
              'QR code',
            ),
          ),
        ],
      ),
    );
  }
}