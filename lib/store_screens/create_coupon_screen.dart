import 'package:flutter/material.dart';
import 'package:qpon/store_screens/scan_screen.dart';
import '../main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  PickedFile? pickedFile;
  final picker = ImagePicker();
  String imagePath = "";
  Future<void> _pickImage() async {
    // ignore: deprecated_member_use
    pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File tmpFile = File(pickedFile!.path);
      final Directory directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final String fileExtension = extension(pickedFile!.path);
      tmpFile = await tmpFile.copy('$path/$storeName$fileExtension');
      imagePath = "$path/$storeName$fileExtension";
      setState(() {
        image = File(pickedFile!.path);
      });
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
          ElevatedButton(
            onPressed: () => _pickImage(),
            child: const Text('Upload your coupon image'),
          ),
          Container(
            child: pickedFile != null
                ? Image.file(
                    File(pickedFile!.path),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : const Text('Pick an image'),
          ),
          ElevatedButton(
            onPressed: () async {
              final body = <String, dynamic>{
                'name': nameController.text.trim(),
                'amount': amountController.text.trim(),
                'expire_date': expiryDate.toString(),
                'is_active': isActive,
                'store': storeId,
                'discount_type': selectedDiscountType
              };
              final record = await client.records.create(
                'coupons',
                body: body,
                files: [
                  http.MultipartFile.fromString(
                    'image',
                    'demo content',
                    filename: imagePath,
                  ),
                ],
              );
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
