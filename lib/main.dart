import 'package:flutter/material.dart';
import './home_screen.dart';
import './coupon_screen.dart';
import './wallet_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final pages = [
    const HomeScreen(),
    const CouponScreen(),
    const WalletScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            "QPon",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
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
          ],
          selectedItemColor: Colors.amber[800],
          currentIndex: pageIndex,
          onTap: _onItemTapped,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: Text(
                  'QPon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                selected: pageIndex==0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text("Your Coupons"),
                selected: pageIndex==1,
                onTap: () {
                  Navigator.of(context).pop();
                  _onItemTapped(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.wallet),
                title: const Text("Wallet"),
                selected: pageIndex==2,
                onTap: () {
                  Navigator.of(context).pop();
                  _onItemTapped(2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.orange,
//           title: const Text(
//             "QPon",
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//               backgroundColor: Colors.orange,
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.card_giftcard),
//               label: 'Coupon',
//               backgroundColor: Colors.green,
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.wallet),
//               label: 'Wallet',
//               backgroundColor: Colors.brown,
//             ),
//           ],
//           selectedItemColor: Colors.amber[800],
//         ),
//         drawer: Drawer(
//           child: ListView(
//             children: const <Widget>[
//               DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Colors.amber,
//                 ),
//                 child: Text(
//                   'QPon',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.home),
//                 title: Text("Home"),
//               ),
//               ListTile(
//                 leading: Icon(Icons.card_giftcard),
//                 title: Text("Your Coupons"),
//               ),
//               ListTile(
//                 leading: Icon(Icons.wallet),
//                 title: Text("Wallet"),
//               ),
//             ],
//           ),
//         ),
//       ),