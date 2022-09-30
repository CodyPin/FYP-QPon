import 'package:flutter/material.dart';
import 'customer_screens/coupon_screen.dart';
import 'customer_screens/home_screen.dart';
import 'customer_screens/wallet_screen.dart';
import 'store_screens/scan_screen.dart';
import 'store_screens/store_coupon_screen.dart';
import 'setting_screen.dart';
import 'login_screen.dart';

import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const Layout(),
  );
}

final client = PocketBase('http://${dotenv.env['HOST']}:${dotenv.env['PORT']}');

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

final navigationKey = GlobalKey<NavigatorState>();

int preLoginPagesIndex = 0;
int storePagesIndex = 0;
int customerPagesIndex = 0;

class _LayoutState extends State<Layout> {
  final preLoginPages = [
    const LoginScreen(),
    const SettingScreen(),
  ];

  final customerPages = [
    const HomeScreen(),
    const CouponScreen(),
    const WalletScreen(),
    const SettingScreen()
  ];

  final storePages = [
    const ScanScreen(),
    const StoreCouponScreen(),
  ];

  void _onPreLoginTapped(int index) {
    setState(() {
      preLoginPagesIndex = index;
    });
  }

  void _onCustomerTapped(int index) {
    setState(() {
      customerPagesIndex = index;
    });
  }

  void _onStoreTapped(int index) {
    setState(() {
      storePagesIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationKey,
      theme: ThemeData(
        fontFamily: 'Merriweather',
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
              fontFamily: 'BungeeSpice',
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: client.authStore.onChange,
          builder: (context, snapshot) {
            if (client.authStore.isValid) {
              // If user logged in
              if (client.authStore.model.profile.getBoolValue("is_store")) {
                // If a store is logged in
                return storePages[storePagesIndex];
              }
              return customerPages[customerPagesIndex];
            }
            // else we are in the login page
            return preLoginPages[preLoginPagesIndex];
          },
        ),
        bottomNavigationBar: StreamBuilder(
          stream: client.authStore.onChange,
          builder: (context, snapshot) {
            if (client.authStore.isValid) {
              // If user logged in
              if (client.authStore.model.profile.getBoolValue("is_store")) {
                // If user is a store
                return BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.qr_code_2),
                      label: 'Scan',
                      backgroundColor: Colors.orange,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.card_giftcard),
                      label: 'Coupon',
                      backgroundColor: Colors.green,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.build_rounded),
                      label: 'Setting',
                      backgroundColor: Colors.grey,
                    ),
                  ],
                  selectedItemColor: Colors.black,
                  currentIndex: storePagesIndex,
                  onTap: _onStoreTapped,
                );
              }
              return BottomNavigationBar(
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
                selectedItemColor: Colors.black,
                currentIndex: customerPagesIndex,
                onTap: _onCustomerTapped,
              );
            }
            // else we are in the login page
            return BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.login),
                  label: 'Login',
                  backgroundColor: Colors.orange,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.build_rounded),
                  label: 'Setting',
                  backgroundColor: Colors.grey,
                ),
              ],
              selectedItemColor: Colors.black,
              currentIndex: preLoginPagesIndex,
              onTap: _onPreLoginTapped,
            );
          },
        ),
      ),
    );
  }
}
