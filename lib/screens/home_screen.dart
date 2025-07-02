import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${_getDisplayName(user)}!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Active Lock-Ins Section
          _buildSectionCard(
            context,
            title: 'Active Lock-Ins',
            icon: Icons.lock,
            child: _buildActiveLockIns(context),
          ),
          
          const SizedBox(height: 16),
          
          // Recent Activity Section
          _buildSectionCard(
            context,
            title: 'Recent Activity',
            icon: Icons.history,
            child: _buildRecentActivity(context),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Actions
          _buildQuickActions(context),
        ],
      ),
    );
  }

  String _getDisplayName(User? user) {
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    return user?.email?.split('@').first ?? 'User';
  }

  Widget _buildSectionCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildActiveLockIns(BuildContext context) {
    // Placeholder for active lock-ins - would fetch from backend
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.fitness_center, color: Colors.white),
          ),
          title: const Text('Daily Workout'),
          subtitle: const Text('Day 3 of 30 • 2 hours remaining'),
          trailing: const Text('Active', style: TextStyle(color: Colors.green)),
          onTap: () {
            context.go('/lock-in/workout-123');
          },
        ),
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.book, color: Colors.white),
          ),
          title: const Text('Read for 1 hour'),
          subtitle: const Text('Day 7 of 14 • 45 minutes remaining'),
          trailing: const Text('Active', style: TextStyle(color: Colors.green)),
          onTap: () {
            context.go('/lock-in/reading-456');
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    // Placeholder for recent activity - would fetch from backend
    return const Column(
      children: [
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Completed: Morning Meditation'),
          subtitle: Text('2 hours ago'),
        ),
        ListTile(
          leading: Icon(Icons.warning, color: Colors.orange),
          title: Text('Warning: Missed workout session'),
          subtitle: Text('Yesterday'),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              context.go('/create');
            },
            icon: const Icon(Icons.add),
            label: const Text('New Lock-In'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              context.go('/feed');
            },
            icon: const Icon(Icons.feed),
            label: const Text('View Feed'),
          ),
        ),
      ],
    );
  }
}
