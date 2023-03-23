import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../main.dart';

class CouponSelectScreen extends StatefulWidget {
  const CouponSelectScreen(
      {Key? key,
      required this.username,
      required this.qrcode,
      required this.closeScreen})
      : super(key: key);

  final String username;
  final String qrcode;
  final Function closeScreen;

  @override
  State<CouponSelectScreen> createState() => _CouponSelectScreenState();
}

class _CouponSelectScreenState extends State<CouponSelectScreen> {
  late Future<void> initCoupons;
  List<RecordModel> coupons = [];
  List<RecordModel> userCoupons = [];
  List<int> couponAmount = [];
  List<int> couponCount = [];
  final userId = client.authStore.model.id;
  var isEmpty = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    initCoupons = fetchUserCoupons();
  }

  Future<bool> fetchUserCoupons() async {
    try {
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
        couponAmount.add(userCoupons[i].getIntValue('amount'));
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
        couponCount = List.filled(coupons.length, 0);
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
        child: Column(children: [
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
                return Center(
                  child: Text(
                    'You don\'t have any coupons yet! \n There is nothing to give to ${widget.username}!',
                    style: const TextStyle(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 200,
                                  ),
                                  child: Image.network(
                                    imageURL,
                                    errorBuilder: (context, error, stackTrace) {
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
                                    if (coupons[index]
                                            .getStringValue('discount_type') ==
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
                                        if (couponCount[index] > 0) {
                                          setState(
                                            () {
                                              couponCount[index]--;
                                            },
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text(
                                      couponCount[index].toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (couponCount[index] <
                                            couponAmount[index]) {
                                          setState(() {
                                            couponCount[index]++;
                                          });
                                        }
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
                              filter: 'user = "${widget.qrcode}"');

                      final receiverCoupons = response.items.toList();

                      for (var i = 0; i < coupons.length; i++) {
                        if (couponCount[i] > 0) {
                          bool created = false;
                          for (var j = 0; j < receiverCoupons.length; j++) {
                            final amount =
                                receiverCoupons[j].getIntValue('amount') +
                                    couponCount[i];

                            final body = <String, dynamic>{
                              'user': widget.qrcode,
                              'coupon': coupons[i].id,
                              'amount': amount,
                            };

                            if (receiverCoupons[j].getStringValue('coupon') ==
                                coupons[i].id) {
                              await client.collection('user_coupons').update(
                                receiverCoupons[j].id,
                                body: body,
                              );

                              final updateBody = <String, dynamic>{
                                'user': userId,
                                'coupon': coupons[i].id,
                                'amount': userCoupons[i].getIntValue('amount') -
                                    couponCount[i],
                              };
                              await client.collection('user_coupons').update(
                                userCoupons[i].id,
                                body: updateBody,
                              );
                              created = true;
                              break;
                            }
                          }
                          if (!created) {
                            final body = <String, dynamic>{
                              'user': widget.qrcode,
                              'coupon': coupons[i].id,
                              'amount': couponCount[i],
                            };

                            await client.collection('user_coupons').create(
                              body: body,
                            );

                            final updateBody = <String, dynamic>{
                              'user': userId,
                              'coupon': coupons[i].id,
                              'amount': userCoupons[i].getIntValue('amount') -
                                  couponCount[i],
                            };
                            await client.collection('user_coupons').update(
                              userCoupons[i].id,
                              body: updateBody,
                            );
                          }
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Coupon(s) gave to ${widget.username}'),
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
        ]),
      ),
    );
  }
}
