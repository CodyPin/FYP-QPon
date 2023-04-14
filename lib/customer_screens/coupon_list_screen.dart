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
  late Future<void> initCoupons;
  List<RecordModel> coupons = [];
  List<int> couponCounts = [];
  List<RecordModel> storeList = [];
  final userId = client.authStore.model.id;
  var isEmpty = false;

  @override
  void initState() {
    super.initState();
    initCoupons = fetchUserCoupons();
  }

  Future<bool> fetchUserCoupons() async {
    try {
      List<RecordModel> userCoupons = [];
      final response = await client.collection('user_coupons').getList(
            page: 1,
            perPage: 100,
            filter: 'user = "$userId"',
          );
      userCoupons = response.items.toList();

      if (userCoupons.isEmpty) {
        isEmpty = true;
        return true;
      }

      var queryString = '';
      for (var i = 0; i < userCoupons.length; i++) {
        var couponId = userCoupons[i].getStringValue('coupon');
        setState(() {
          couponCounts.add(userCoupons[i].getIntValue('amount'));
        });
        if (i != userCoupons.length - 1) {
          queryString += 'id="$couponId" || ';
          continue;
        }
        queryString += 'id="$couponId"';
      }

      final couponsResponse = await client
          .collection('coupons')
          .getList(page: 1, perPage: 100, filter: queryString);
      setState(() {
        coupons = couponsResponse.items.toList();
      });

      final storeResponse = await client.collection('stores').getList();
      for (var i = 0; i < coupons.length; i++) {
        for (var j = 0; j < storeResponse.items.length; j++) {
          if (coupons[i].getStringValue('store') == storeResponse.items[j].id) {
            setState(() {
              storeList.add(storeResponse.items[j]);
            });
          }
        }
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Your Coupons",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            FutureBuilder(
              future: initCoupons,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (isEmpty) {
                    return const Center(
                      child: Text(
                        "You don't have any coupons yet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      final imageURL = client
                          .getFileUrl(coupons[index],
                              coupons[index].getStringValue('image'))
                          .toString();

                      if(couponCounts[index] == 0) return const SizedBox();

                      return GestureDetector(
                        onTap: () async{
                          // go to this coupon's details screen
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CouponScreen(
                                coupon: coupons[index],
                                store: storeList[index].getStringValue('name'),
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
                          fetchUserCoupons();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 200.0,
                                    ),
                                    child: Hero(
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
                                  ),
                                  Text(
                                    coupons[index].getStringValue('name'),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    coupons[index].getStringValue('description'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "You have ${couponCounts[index]} of this coupon",
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
      ),
    );
  }
}
