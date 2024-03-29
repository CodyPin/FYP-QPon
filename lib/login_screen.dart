import 'package:flutter/material.dart';
import 'package:qpon/register_screen.dart';
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
          Text(
            "Login",
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
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
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).iconTheme.color,
            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(90, 5),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_circle_right,
                  size: 10,
                ),
                label: const Text(
                  'Register',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Sign in function
  Future signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await client.collection('users').authWithPassword(
        email,
        password,
      );
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
