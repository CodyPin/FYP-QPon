import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

final client = PocketBase('http://10.0.2.2:8090');

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenstate();
}

class _LoginScreenstate extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            cursorColor: Colors.orange,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'Email',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: passwordController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              icon: Icon(Icons.password),
              labelText: 'Password',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await signIn();
            },
            icon: const Icon(
              Icons.lock_open,
              size: 32,
            ),
            label: const Text(
              'Sign In',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }

  // Sign in function
  Future signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await client.users.authViaEmail(
        email,
        password,
      );
    } catch (e) {
      return false;
    }
    return true;
  }
}
