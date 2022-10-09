import 'package:flutter/material.dart';
import '../main.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

String storeId = "";
String storeName = "";

class _ScanScreenState extends State<ScanScreen> {
  Future fetchStoreData() async {
    final response = await client.records.getList('stores',
        page: 1,
        perPage: 1,
        filter: 'owner = "${client.authStore.model.profile.id}"');
    storeId = response.items[0].id;
    storeName = response.items[0].getStringValue('name');
  }

  @override
  Widget build(BuildContext context) {
    final username = client.authStore.model.profile.getStringValue('name');
    fetchStoreData();

    return Center(
      child: Text(
        "Welcome $username",
        style: TextStyle(
          color: Colors.green[900],
          fontSize: 45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
