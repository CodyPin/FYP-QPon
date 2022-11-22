import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

import '../main.dart';
import 'coupon_screen.dart';

class CouponListScreen extends StatefulWidget {
  const CouponListScreen({Key? key}) : super(key: key);

  @override
  State<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  List<RecordModel> coupons = [];
  List<int> couponCounts = [];
  final userId = client.authStore.model.id;

  Future<bool> fetchUserCoupons() async {
    try {
      List<RecordModel> userCoupons = [];
      final response = await client.collection('user_coupons').getList(
          page: 1, perPage: 100, filter: 'user = "$userId"',);
      userCoupons = response.items.toList();

      var queryString = '';
      for (var i = 0; i < userCoupons.length; i++) {
        var couponId = userCoupons[i].getStringValue('coupon');
        couponCounts.add(userCoupons[i].getIntValue('amount'));
        if (i != userCoupons.length - 1) {
          queryString += 'id="$couponId" || ';
          continue;
        }
        queryString += 'id="$couponId"';
      }

      final couponsResponse = await client.collection('coupons')
          .getList(page: 1, perPage: 100, filter: queryString);
      coupons = couponsResponse.items.toList();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text(
            "Your Coupons",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          FutureBuilder(
            future: fetchUserCoupons(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      final imageURL = client
                          .getFileUrl(coupons[index],
                              coupons[index].getStringValue('image'))
                          .toString();

                      return GestureDetector(
                        onTap: () {
                          // go to this coupon's details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CouponScreen(
                                coupon: coupons[index],
                                image: Image.network(
                                  imageURL,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.card_giftcard,
                                        size: 100);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Hero(
                                    tag: coupons[index].id,
                                    child: Image.network(
                                      imageURL,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.card_giftcard,
                                            size: 100);
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
                                    coupons[index]
                                        .getStringValue('description'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "You have ${couponCounts[index]} of these coupons",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  // Image.network(imageURL),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const CreateCouponScreen(),
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
