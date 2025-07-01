import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    if (kIsWeb) {
      _googleSignIn.initialize(
        clientId: '650324673364-7eg8kvpk9bkko3ub8hprriaeskocoalu.apps.googleusercontent.com',
      );
    } else {
      _googleSignIn.initialize();
    }
  }

  Future<void> signInWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email login failed: $e')),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Use the authenticate method for both platforms
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      
      // Obtain the auth details from the account
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception('Failed to get idToken');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      // Once signed in, sign in to Firebase with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lock-In Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: signInWithEmail, child: const Text("Sign in with Email")),
            const SizedBox(height: 8),
            if (_googleSignIn.supportsAuthenticate())
              ElevatedButton(onPressed: signInWithGoogle, child: const Text("Sign in with Google"))
            else if (kIsWeb)
              // For web, use the renderButton from web_only.dart
              web.renderButton()
            else
              // Fallback for unsupported platforms
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Google Sign-In not supported on this platform')),
                  );
                },
                child: const Text("Sign in with Google (Not Supported)"),
              ),
          ],
        ),
      ),
    );
  }
}