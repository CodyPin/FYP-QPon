import 'package:flutter/material.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          const Text(
            "Login",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
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
              var signInOk = await signIn();
              // if sign in failed, show error message
              if (!signInOk) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login failed'),
                  ),
                );
              }
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
