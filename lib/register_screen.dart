import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "Register",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          TextField(
            cursorColor: Colors.orange,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'Email',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              icon: Icon(Icons.password),
              labelText: 'Password',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              icon: Icon(Icons.password),
              labelText: 'Confirm Password',
            ),
          ),
        ],
      ),
    );
  }
}
