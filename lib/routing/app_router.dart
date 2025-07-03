import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../features/auth/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/create_lockin_screen.dart';
import '../screens/lockin_details_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/app_shell.dart';

/// A ChangeNotifier that listens to a Stream and notifies listeners when the stream emits new values
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final isLoggingIn = state.matchedLocation == '/login';

      debugPrint('Router redirect: user=${user?.uid}, isLoggedIn=$isLoggedIn, location=${state.matchedLocation}');

      if (!isLoggedIn && !isLoggingIn) {
        debugPrint('Redirecting to login - no user authenticated');
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        debugPrint('Redirecting to home - user already authenticated');
        return '/home';
      }

      return null;
    },
    routes: [
      // Login route (outside shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),

      // Shell route with navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/feed',
            name: 'feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/create',
            name: 'create',
            builder: (context, state) => const CreateLockInScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/lock-in/:id',
            name: 'lock-in-details',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return LockInDetailsScreen(lockInId: id);
            },
          ),
        ],
      ),
    ],
  );
}