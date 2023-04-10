import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qpon/customer_screens/scan_screen.dart';
import '../qrcode_screen.dart';
import '../main.dart';
import 'coupon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> initCoupons;
  List<RecordModel> coupons = [];
  List<RecordModel> sevenDayCoupons = [];
  List<int> couponCounts = [];
  List<RecordModel> storeList = [];
  var isEmpty = false;
  var isLoading = false;
  final userId = client.authStore.model.id;

  @override
  void initState() {
    super.initState();
    initCoupons = fetchUserCoupons();
  }

  Future<bool> fetchUserCoupons() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<RecordModel> userCoupons = [];
      final response = await client.collection('user_coupons').getList(
            page: 1,
            perPage: 100,
            filter: 'user = "$userId"',
          );
      userCoupons = response.items.toList();

      if (userCoupons.isEmpty) {
        setState(() {
          isEmpty = true;
          isLoading = false;
        });
        return true;
      }

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

      final couponsResponse = await client
          .collection('coupons')
          .getList(page: 1, perPage: 100, filter: queryString);
      coupons = couponsResponse.items.toList();

      final storeResponse = await client.collection('stores').getList();
      for (var i = 0; i < coupons.length; i++) {
        for (var j = 0; j < storeResponse.items.length; j++) {
          if (coupons[i].getStringValue('store') == storeResponse.items[j].id) {
            storeList.add(storeResponse.items[j]);
          }
        }
      }

      for (var i = 0; i < coupons.length; i++) {
        var expiryDate = DateTime.parse(DateFormat('yyyy-MM-dd hh:mm').format(
            DateFormat('yyyy-MM-dd hh:mm:ss')
                .parse(coupons[i].getStringValue('expire_date'))));
        if (expiryDate.compareTo(DateTime.now()) > 0) {
          sevenDayCoupons.add(coupons[i]);
        }
      }
      setState(() {
        isLoading = false;
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Widget buildCard(RecordModel coupon, name, store, image) => SizedBox(
        width: 150,
        height: 300,
        child: GestureDetector(
          onTap: () {
            // go to this coupon's details screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CouponScreen(
                  coupon: coupon,
                  store: store,
                  image: Image.network(
                    image,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.card_giftcard, size: 100);
                    },
                  ),
                ),
              ),
            );
          },
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200.0,
                ),
                child: Image.network(
                  image,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.card_giftcard, size: 20);
                  },
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                store,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final username = client.authStore.model.getStringValue('username');

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: FutureBuilder(
        future: initCoupons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome $username!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "You do not have any coupons yet!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "Go get some coupons!",
                      style:  TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Welcome $username",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Coupon(s) due in 7 days:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sevenDayCoupons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildCard(
                      sevenDayCoupons[index],
                      sevenDayCoupons[index].getStringValue('name'),
                      storeList[index].getStringValue('name'),
                      client
                          .getFileUrl(sevenDayCoupons[index],
                              sevenDayCoupons[index].getStringValue('image'))
                          .toString(),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScanScreen(),
                ),
              );
            },
            child: const Icon(Icons.camera),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodeScreen(
                    title: 'Your Account QRCode',
                    qrcode: client.authStore.model.id,
                  ),
                ),
              );
            },
            child: const Icon(Icons.qr_code),
          ),
        ],
      ),
    );
  }
}
