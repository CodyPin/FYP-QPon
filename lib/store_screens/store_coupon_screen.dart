import 'package:flutter/material.dart';
import 'package:pocketbase/src/dtos/record_model.dart';
import 'package:intl/intl.dart';
import 'package:qpon/store_screens/edit_coupon_screen.dart';
import '../main.dart';
import '../qrcode_screen.dart';
import '../utils/color.dart';

class StoreCouponScreen extends StatelessWidget {
  const StoreCouponScreen({Key? key, required this.coupon, required this.image})
      : super(key: key);

  final RecordModel coupon;
  final Image image;

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget confirmButton = ElevatedButton(
      style: ButtonStyle(
        foregroundColor: getColor(Colors.white, Colors.red),
        backgroundColor: getColor(Colors.red, Colors.white),
      ),
      onPressed: () async {
        try {
          var listOfUserCoupons = await client.collection('user_coupons').getList(
            page:1,
            perPage: 1000,
            filter: 'coupon = "${coupon.id}"',
          );
          for (var userCoupon in listOfUserCoupons.items) {
            await client.collection('user_coupons').delete(userCoupon.id);
          }

          await client.collection('coupons').delete(coupon.id);
        } catch (e) {
          print(e);
        }
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coupon deleted'),
          ),
        );
      },
      child: const Text("Confirm"),
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Confirm delete"),
      content: const Text("Are you sure you want to delete this coupon?"),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Coupon Details",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
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
                          DateFormat('yyyy-MM-dd hh:mm:ss').parse(
                            coupon.getStringValue('expire_date')
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Coupon Is Active? ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        coupon.getStringValue('is_active'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditCouponScreen(coupon: coupon, initImage: image),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: getColor(Colors.white, Colors.blue),
                    backgroundColor: getColor(Colors.blue, Colors.white),
                  ),
                  child: const Text(
                    'Edit Coupon',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: getColor(Colors.white, Colors.red),
                    backgroundColor: getColor(Colors.red, Colors.white),
                  ),
                  child: const Text(
                    'Delete Coupon?',
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeScreen(
                      title: 'Your Coupon QRCode',
                      qrcode: coupon.id,
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
      ),
    );
  }
}
