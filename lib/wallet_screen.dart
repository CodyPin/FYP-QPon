import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Text('Your Wallet'),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.card_giftcard),
                  ),
                  const Text('Coupon'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.card_giftcard),
                  ),
                  const Text('Stamps'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.card_giftcard),
                  ),
                  const Text('Your ID'),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
