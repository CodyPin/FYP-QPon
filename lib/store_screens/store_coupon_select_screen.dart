import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qpon/store_screens/store_scan_screen.dart';

import '../main.dart';

class StoreCouponSelectScreen extends StatefulWidget {
  const StoreCouponSelectScreen(
      {Key? key,
      required this.username,
      required this.userID,
      required this.qrcode,
      required this.closeScreen})
      : super(key: key);

  final String userID;
  final String username;
  final String qrcode;
  final Function closeScreen;

  @override
  State<StoreCouponSelectScreen> createState() =>
      _StoreCouponSelectScreenState();
}

class _StoreCouponSelectScreenState extends State<StoreCouponSelectScreen> {
  late Future<void> initCoupons;
  List<RecordModel> coupons = [];
  List<int> couponAmounts = [];
  var isEmpty = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    initCoupons = fetchStoreCoupons();
  }

  Future<bool> fetchStoreCoupons() async {
    try {
      final response = await client
          .collection('coupons')
          .getList(page: 1, perPage: 100, filter: 'store = "$storeId"');
      if (response.items.isEmpty) {
        isEmpty = true;
        return true;
      }
      setState(() {
        coupons = response.items.toList();
        couponAmounts = List.filled(coupons.length, 0);
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Select coupon(s) to give to ${widget.username}",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            FutureBuilder(
              future: initCoupons,
              builder: (context, snapshot) {
                if (isEmpty) {
                  return const Center(
                    child: Text(
                      'You don\'t have any coupons yet! \n Go create some coupons!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: coupons.length,
                      itemBuilder: (context, index) {
                        final imageURL = client
                            .getFileUrl(coupons[index],
                                coupons[index].getStringValue('image'))
                            .toString();

                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 200,
                                    ),
                                    child: Image.network(
                                      imageURL,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.card_giftcard,
                                          size: 50,
                                        );
                                      },
                                    ),
                                  ),
                                  Text(
                                    coupons[index].getStringValue('name'),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    () {
                                      if (coupons[index].getStringValue(
                                              'discount_type') ==
                                          'percent') {
                                        return 'Discount: ${coupons[index].getStringValue('discount')}%';
                                      } else {
                                        return 'Discount: \$${coupons[index].getStringValue('amount')}';
                                      }
                                    }(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (couponAmounts[index] > 0) {
                                            setState(
                                              () {
                                                couponAmounts[index]--;
                                              },
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(
                                        couponAmounts[index].toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            couponAmounts[index]++;
                                          });
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        isLoading = true;

                        final response = await client
                            .collection('user_coupons')
                            .getList(
                                page: 1,
                                perPage: 100,
                                filter: 'user = "${widget.userID}"');

                        final userCoupons = response.items.toList();

                        for (var i = 0; i < coupons.length; i++) {
                          if (couponAmounts[i] > 0) {
                            bool created = false;
                            for (var j = 0; j < userCoupons.length; j++) {
                              final amount =
                                  userCoupons[j].getIntValue('amount') +
                                      couponAmounts[i];

                              final body = <String, dynamic>{
                                'user': widget.userID,
                                'coupon': coupons[i].id,
                                'amount': amount,
                              };

                              if (userCoupons[j].getStringValue('coupon') ==
                                  coupons[i].id) {
                                await client.collection('user_coupons').update(
                                      userCoupons[j].id,
                                      body: body,
                                    );
                                created = true;
                                break;
                              }
                            }
                            if (!created) {
                              final body = <String, dynamic>{
                                'user': widget.userID,
                                'coupon': coupons[i].id,
                                'amount': couponAmounts[i],
                              };

                              await client.collection('user_coupons').create(
                                    body: body,
                                  );
                            }
                          }
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Coupon(s) added to ${widget.username}'),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                        widget.closeScreen();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
