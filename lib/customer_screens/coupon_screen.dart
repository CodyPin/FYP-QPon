import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

import '../main.dart';
import '../qrcode_screen.dart';
import '../utils/color.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({Key? key, required this.coupon, required this.image, required this.store})
      : super(key: key);

  final RecordModel coupon;
  final String store;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupon Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 500.0,
            ),
            child: Hero(
              tag: coupon.id,
              child: image,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Store: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      store,
                    ),
                  ],
                ),
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
                        DateFormat('yyyy-MM-dd hh:mm:ss')
                            .parse(coupon.getStringValue('expire_date')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final record = await client
                  .collection('user_coupons')
                  .getFirstListItem(
                      'user = "${client.authStore.model.id}" && coupon = "${coupon.id}"');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodeScreen(
                    title: 'Your Coupon QRCode',
                    qrcode: record.id,
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
