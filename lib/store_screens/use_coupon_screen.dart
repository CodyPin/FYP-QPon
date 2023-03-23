import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../main.dart';

class UseCouponScreen extends StatefulWidget {
  const UseCouponScreen(
      {Key? key,
      required this.username,
      required this.userID,
      required this.userCoupon,
      required this.closeScreen})
      : super(key: key);

  final String userID;
  final String username;
  final RecordModel userCoupon;
  final Function closeScreen;

  @override
  State<UseCouponScreen> createState() => _UseCouponScreenState();
}

class _UseCouponScreenState extends State<UseCouponScreen> {
  late RecordModel coupon;
  var useCount = 0;

  Future<bool> fetchCoupon() async {
    try {
      final response = await client
          .collection('coupons')
          .getOne(widget.userCoupon.getStringValue('coupon'));

      setState(() {
        coupon = response;
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchCoupon();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.closeScreen();
            Navigator.of(context).pop();
          },
        ),
        title: Text('Use Coupon for ${widget.username}'),
      ),
      body: FutureBuilder(
        future: fetchCoupon(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final imageURL = client
                .getFileUrl(coupon, coupon.getStringValue('image'))
                .toString();

            final couponAmount = coupon.getStringValue('type') == 'percent'
                ? '${coupon.getIntValue('amount')}%'
                : '\$${coupon.getIntValue('amount')}';

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    imageURL,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.card_giftcard, size: 100);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Discount: $couponAmount",
                  ),
                  Text(
                      "User has ${widget.userCoupon.getIntValue('amount')} of this coupon"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (useCount > 0) {
                            setState(
                              () {
                                useCount--;
                              },
                            );
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        useCount.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (useCount <
                              widget.userCoupon.getIntValue('amount')) {
                            setState(() {
                              useCount++;
                            });
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (useCount > 0) {
                        final newAmount =
                            widget.userCoupon.getIntValue('amount') - useCount;
                        final body = {
                          'user': widget.userID,
                          'coupon': coupon.id,
                          'amount': newAmount,
                        };
                        await client.collection('user_coupons').update(
                              widget.userCoupon.id,
                              body: body,
                            );

                        widget.closeScreen();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Coupon used!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text('Use Coupon'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
