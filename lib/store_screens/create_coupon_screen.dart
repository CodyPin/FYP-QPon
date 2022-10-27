import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qpon/store_screens/scan_screen.dart';
import '../main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({Key? key}) : super(key: key);

  @override
  State<CreateCouponScreen> createState() => _CreateCouponState();
}

final List<String> discountType = <String>['cash', 'percentage'];

class _CreateCouponState extends State<CreateCouponScreen> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  String selectedDiscountType = discountType.first;

  DateTime date = DateTime.now();
  DateTime? expiryDate;

  bool isActive = false;
  String isActiveText = 'No';

  File? image;

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

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  Future<bool> createCoupon() async {

    try {
      final body = <String, dynamic>{
        'name': nameController.text.trim(),
        'amount': amountController.text.trim(),
        'expire_date': expiryDate.toString(),
        'is_active': isActive,
        'store': storeId,
        'discount_type': selectedDiscountType
      };

      if (image?.path != null) {
        final record = await client.records.create(
          'coupons',
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
        final record = await client.records.create(
          'coupons',
          body: body,
        );
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Create a new coupon',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(date.year),
                      lastDate: DateTime(date.year + 10),
                    );
                    if (newDate == null) return;
                    setState(() {
                      date = newDate;
                      expiryDate = newDate;
                    });
                  },
                  child: const Text('Select expiry date'),
                ),
                Text(
                  'Expiry Date: ${date.year}/${date.month}/${date.day}',
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
                      : const Text('Picked image will be shown here'),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var isCreated = await createCoupon();
              if (!isCreated){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Coupon creation failed'),
                  ),
                );
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Coupon created successfully'),
                  ),
                );
              }
            },
            style: ButtonStyle(
              foregroundColor: getColor(Colors.white, Colors.green),
              backgroundColor: getColor(Colors.green, Colors.white),
            ),
            child: const Text(
              'Create',
              style: TextStyle(
                fontSize: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
