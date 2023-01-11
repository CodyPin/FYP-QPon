import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qpon/store_screens/scan_screen.dart';
import '../main.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/color.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class EditCouponScreen extends StatefulWidget {
  const EditCouponScreen({Key? key, required this.coupon, required this.initImage}) : super(key: key);

  final RecordModel coupon;
  final Image initImage;

  @override
  State<EditCouponScreen> createState() => _EditCouponScreenState();
}

final List<String> discountType = <String>['cash', 'percentage'];

class _EditCouponScreenState extends State<EditCouponScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  String selectedDiscountType = discountType.first;

  DateTime expiryDate = DateTime.now();

  bool isActive = false;
  String isActiveText = 'No';

  File? image;

  Future<bool> updateCoupon() async {
    try {
      final body = <String, dynamic>{
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'amount': amountController.text.trim(),
        'expire_date': expiryDate.toString(),
        'is_active': isActive,
        'image': '${nameController.text.trim()}.png',
        'store': storeId,
        'discount_type': selectedDiscountType
      };

      if (image?.path != null) {
        await client.collection('coupons').update(
          widget.coupon.id,
          body: body,
          files: [
            http.MultipartFile.fromString(
              'image',
              'png',
              filename: image!.path,
            ),
          ],
        );
      } else {
        await client.collection('coupons').update(
          widget.coupon.id,
          body: body,
        );
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<void> _pickImage(source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    RecordModel coupon = widget.coupon;
    nameController.text = coupon.getStringValue('name');
    descriptionController.text = coupon.getStringValue('description');
    amountController.text = coupon.getStringValue('amount');
    selectedDiscountType = coupon.getStringValue('discount_type');
    isActive = coupon.getBoolValue('is_active');

    ImageProvider initImage = widget.initImage.image;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Update Coupon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextField(
              controller: nameController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.abc),
                labelText: 'Name of your coupon',
              ),
            ),
            TextField(
              controller: descriptionController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.abc),
                labelText: 'Description of your coupon',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: selectedDiscountType,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedDiscountType = value!;
                    });
                  },
                  items:
                  discountType.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: amountController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.money),
                      labelText: 'Amount',
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: expiryDate,
                        firstDate: DateTime(expiryDate.year),
                        lastDate: DateTime(expiryDate.year + 10),
                      );
                      if (newDate == null) return;
                      setState(() {
                        expiryDate = newDate;
                      });
                    },
                    child: const Text('Select expiry date'),
                  ),
                  Text(
                    'Expiry Date: ${expiryDate.year}/${expiryDate.month}/${expiryDate.day}',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Activate now?'),
                Switch(
                  value: isActive,
                  onChanged: (bool value) {
                    setState(
                          () {
                        isActive = value;
                        if (isActive) {
                          isActiveText = 'Yes';
                        } else {
                          isActiveText = 'No';
                        }
                      },
                    );
                  },
                ),
                Text(isActiveText),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            child: Row(
                              children: const [
                                Icon(Icons.image),
                                Text('Pick from gallery'),
                              ],
                            )),
                        ElevatedButton(
                            onPressed: () => _pickImage(ImageSource.camera),
                            child: Row(
                              children: const [
                                Icon(Icons.camera_alt),
                                Text('Pick from camera'),
                              ],
                            )),
                      ]),
                  Container(
                    child: image != null
                        ? Image.file(
                      File(image!.path),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                        : Image(image: initImage),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var isCreated = await updateCoupon();
                if (!isCreated){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coupon update failed'),
                    ),
                  );
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coupon updated successfully'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ButtonStyle(
                foregroundColor: getColor(Colors.white, Colors.green),
                backgroundColor: getColor(Colors.green, Colors.white),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
