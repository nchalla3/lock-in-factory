import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as web;
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late GoogleSignIn _googleSignIn;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }

  void _initializeGoogleSignIn() {
    try {
      _googleSignIn = GoogleSignIn.instance;
      if (kIsWeb) {
        _googleSignIn.initialize(
          clientId: '650324673364-7eg8kvpk9bkko3ub8hprriaeskocoalu.apps.googleusercontent.com',
        );
      } else {
        _googleSignIn.initialize();
      }
      debugPrint('GoogleSignIn initialized successfully');
    } catch (e) {
      debugPrint('GoogleSignIn initialization failed: $e');
    }
  }

  Future<void> signInWithEmail() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      _showError('Please enter both email and password');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      debugPrint('Attempting email sign-in for: ${_emailController.text.trim()}');
      
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      debugPrint('Email sign-in successful for user: ${userCredential.user?.uid}');
      
      if (mounted) {
        debugPrint('Navigating to /home after successful email login');
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth error: ${e.code} - ${e.message}');
      String message = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      _showError(message);
    } catch (e) {
      debugPrint('Unexpected error during email sign-in: $e');
      _showError('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() => _isLoading = true);
    
    try {
      debugPrint('Attempting Google sign-in...');
      
      GoogleSignInAccount? googleUser;
      
      if (kIsWeb) {
        // For web, try signInSilently first, then fallback to signIn
        try {
          googleUser = await _googleSignIn.signInSilently();
        } catch (e) {
          debugPrint('Silent sign-in failed, trying normal sign-in: $e');
        }
        
        if (googleUser == null) {
          googleUser = await _googleSignIn.signIn();
        }
      } else {
        // For mobile platforms
        googleUser = await _googleSignIn.signIn();
      }
      
      if (googleUser == null) {
        debugPrint('Google sign-in was cancelled by user');
        _showError('Google sign-in was cancelled');
        return;
      }
      
      debugPrint('Google user obtained: ${googleUser.email}');
      
      // Obtain the auth details from the account
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      
      if (idToken == null) {
        throw Exception('Failed to get idToken from Google');
      }
      
      debugPrint('Google auth tokens obtained successfully');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      debugPrint('Signing in to Firebase with Google credential...');
      
      // Once signed in, sign in to Firebase with the credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      debugPrint('Firebase sign-in successful for user: ${userCredential.user?.uid}');
      
      if (mounted) {
        debugPrint('Navigating to /home after successful Google login');
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth error during Google sign-in: ${e.code} - ${e.message}');
      _showError('Google sign-in failed: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error during Google sign-in: $e');
      _showError('Google sign-in failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
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
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : signInWithEmail,
              child: _isLoading 
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Sign in with Email"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : signInWithGoogle,
              child: _isLoading 
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Sign in with Google"),
            ),
            
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Text('Signing in...', style: TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}