import 'package:flutter/material.dart';
import 'main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  Future<bool> register(username, email, password, passwordConfirm) async {
    final body = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'is_store': false,
    };
    final response = await client.collection('users').create(body: body);

    if (response.id.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Register",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: usernameController,
              cursorColor: Colors.orange,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Username',
              ),
            ),
            const SizedBox(
              height: 20,
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
            TextField(
              controller: passwordConfirmController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (usernameController.text == "" ||
                    emailController.text == "" ||
                    passwordController.text == "" ||
                    passwordConfirmController.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill in all fields"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                } else if (passwordController.text !=
                    passwordConfirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                else if(usernameController.text.contains(' ')){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Username cannot contain spaces"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                final isRegister = register(
                  usernameController.text,
                  emailController.text,
                  passwordController.text,
                  passwordConfirmController.text,
                );

                if (await isRegister) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Registration successful"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Registration failed"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
