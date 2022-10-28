import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qpon/store_screens/store_coupon_screen.dart';
import '../main.dart';
import './scan_screen.dart';
import 'create_coupon_screen.dart';

class StoreCouponListScreen extends StatefulWidget {
  const StoreCouponListScreen({Key? key}) : super(key: key);

  @override
  State<StoreCouponListScreen> createState() => _StoreCouponListState();
}

class _StoreCouponListState extends State<StoreCouponListScreen> {
  List<RecordModel> coupons = [];

  Future<bool> fetchStoreCoupons() async {
    try {
      final response = await client.records.getList('coupons',
          page: 1, perPage: 100, filter: 'store = "$storeId"');
      coupons = response.items.toList();
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
            "Your Store's Coupons",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          FutureBuilder(
            future: fetchStoreCoupons(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      final imageURL = client.records
                          .getFileUrl(coupons[index],
                              coupons[index].getStringValue('image'))
                          .toString();

                      return GestureDetector(
                        onTap: () {
                          // go to this coupon's details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreCouponScreen(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCouponScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
