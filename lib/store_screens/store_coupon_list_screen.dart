import 'package:flutter/material.dart';
import '../main.dart';
import 'create_coupon_screen.dart';

class StoreCouponListScreen extends StatefulWidget {
  const StoreCouponListScreen({Key? key}) : super(key: key);

  @override
  State<StoreCouponListScreen> createState() => _StoreCouponListState();
}

class _StoreCouponListState extends State<StoreCouponListScreen> {
  @override
  Widget build(BuildContext context) {
    final username = client.authStore.model.profile.getStringValue('name');

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
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: SizedBox(
                        height: 100,
                        child: Center(
                          child: Text('Coupon Example${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateCouponScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
