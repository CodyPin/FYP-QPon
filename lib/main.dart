import 'package:flutter/material.dart';
import './home_screen.dart';
import './coupon_screen.dart';
import './wallet_screen.dart';
import './setting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Layout(),
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int pageIndex = 0;

  final pages = [
    const HomeScreen(),
    const CouponScreen(),
    const WalletScreen(),
    const SettingScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'IndieFlower',
        scaffoldBackgroundColor: Colors.orange[50],
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            "QPon",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'BungeeSpice'),
          ),
          centerTitle: true,
        ),
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'Coupon',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
              backgroundColor: Colors.brown,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_rounded),
              label: 'Setting',
              backgroundColor: Colors.grey,
            ),
          ],
          selectedItemColor: Colors.white,
          currentIndex: pageIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
