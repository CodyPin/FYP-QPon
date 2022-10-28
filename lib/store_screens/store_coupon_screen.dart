import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/src/dtos/record_model.dart';
import 'package:intl/intl.dart';
import '../main.dart';
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
      child: const Text("Confirm"),
      onPressed: () async{
        try {
          await client.records.delete('coupons', coupon.id);
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
            children:[
              ElevatedButton(
                onPressed: () async {

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
            ]
          )
        ],
      ),
    );
  }
}
