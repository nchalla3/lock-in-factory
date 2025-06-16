import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _emailController),
          TextField(controller: _passwordController, obscureText: true),
          ElevatedButton(
            onPressed: () async {
              try {
                await auth.signInWithEmail(
                  _emailController.text,
                  _passwordController.text,
                );
              } catch (e) {
                print('Login failed: $e');
              }
            },
            child: Text('Login'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await auth.signInWithGoogle();
              } catch (e) {
                print('Google Sign-In failed: $e');
              }
            },
            child: Text('Sign in with Google'),
          ),
        ],
      ),
    );
  }
}
