import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qpon/store_screens/store_coupon_screen.dart';
import './store_scan_screen.dart';
import '../main.dart';
import 'create_coupon_screen.dart';

class StoreCouponListScreen extends StatefulWidget {
  const StoreCouponListScreen({Key? key}) : super(key: key);

  @override
  State<StoreCouponListScreen> createState() => _StoreCouponListState();
}

class _StoreCouponListState extends State<StoreCouponListScreen> {
  late Future<void> initCoupons;
  List<RecordModel> coupons = [];
  var isEmpty = false;

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
      if(response.items.isEmpty) {
        isEmpty = true;
        return true;
      }
      setState(() {
        coupons = response.items.toList();
      });
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
              "Your Store's Coupons",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            FutureBuilder(
              future: initCoupons,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if(isEmpty) {
                    return const Center(
                      child: Text(
                        'You have no coupons yet, create one with the button below!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
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

                      return GestureDetector(
                        onTap: () async{
                          // go to this coupon's details screen
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreCouponScreen(
                                coupon: coupons[index],
                                image: Image.network(
                                  imageURL,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.card_giftcard,
                                      size: 100,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                          fetchStoreCoupons();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                          return const Icon(
                                              Icons.card_giftcard,
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async{
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateCouponScreen(),
                ),
              );
              fetchStoreCoupons();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
