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
  bool _showEmailForm = false;

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
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate input
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    try {
      // First try to sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // If sign in fails, try to create a new account
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account created successfully!')),
            );
          }
        } catch (createError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create account: $createError')),
            );
          }
        }
      } else {
        if (mounted) {
          String errorMessage = 'Email login failed';
          if (e is FirebaseAuthException) {
            switch (e.code) {
              case 'invalid-email':
                errorMessage = 'Invalid email address';
                break;
              case 'wrong-password':
                errorMessage = 'Incorrect password';
                break;
              case 'weak-password':
                errorMessage = 'Password is too weak (minimum 6 characters)';
                break;
              case 'email-already-in-use':
                errorMessage = 'An account already exists with this email';
                break;
              default:
                errorMessage = 'Email login failed: ${e.message}';
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
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
            if (!_showEmailForm) ...[
              // Initial choice screen
              const Text(
                "Welcome to Lock-In Factory",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                "Choose how you'd like to sign in:",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showEmailForm = true;
                    });
                  },
                  child: const Text("Sign in with Email"),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _buildGoogleSignInButton(),
              ),
            ] else ...[
              // Email form screen
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showEmailForm = false;
                        _emailController.clear();
                        _passwordController.clear();
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Sign in with Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: signInWithEmail,
                  child: const Text("Sign In"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    if (_googleSignIn.supportsAuthenticate()) {
      return ElevatedButton(
        onPressed: signInWithGoogle,
        child: const Text("Continue with Google"),
      );
    } else if (kIsWeb) {
      // For web, use the renderButton from web_only.dart
      return web.renderButton();
    } else {
      // Fallback for unsupported platforms
      return ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Sign-In not supported on this platform')),
          );
        },
        child: const Text("Continue with Google (Not Supported)"),
      );
    }
  }
}