import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 800;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lock-In Factory'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: isWideScreen ? null : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _isDrawerOpen = !_isDrawerOpen;
                });
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
          body: Row(
            children: [
              if (isWideScreen || _isDrawerOpen)
                _buildSidebar(context, isWideScreen),
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, bool isWideScreen) {
    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        children: [
          if (!isWideScreen)
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isDrawerOpen = false;
                  });
                },
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  route: '/home',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.feed,
                  title: 'Feed',
                  route: '/feed',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.add_circle,
                  title: 'Create Lock-In',
                  route: '/create',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person,
                  title: 'Profile',
                  route: '/profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path == route;
    
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: isSelected,
      onTap: () {
        context.go(route);
        if (!MediaQuery.of(context).size.width >= 800) {
          setState(() {
            _isDrawerOpen = false;
          });
        }
      },
    );
  }
}