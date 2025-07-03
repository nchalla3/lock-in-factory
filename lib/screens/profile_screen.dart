import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _displayNameController.text = user?.displayName ?? '';
    _bioController.text = ''; // Would load from user profile in backend
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Profile Header
          _buildProfileHeader(context, user),
          
          const SizedBox(height: 24),
          
          // Stats Section
          _buildStatsSection(context),
          
          const SizedBox(height: 16),
          
          // Active Lock-Ins
          _buildActiveLockInsSection(context),
          
          const SizedBox(height: 16),
          
          // Achievements
          _buildAchievementsSection(context),
          
          const SizedBox(height: 16),
          
          // Settings
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User? user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Text(
                      _getInitials(user),
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            
            if (_isEditing) ...[
              TextField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ] else ...[
              Text(
                _displayNameController.text.isNotEmpty
                    ? _displayNameController.text
                    : user?.email?.split('@').first ?? 'User',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (_bioController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _bioController.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                _buildStatCard(context, 'Total Lock-Ins', '12', Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard(context, 'Completed', '8', Colors.green),
                const SizedBox(width: 12),
                _buildStatCard(context, 'Success Rate', '67%', Colors.purple),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                _buildStatCard(context, 'Current Streak', '5 days', Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard(context, 'Longest Streak', '23 days', Colors.red),
                const SizedBox(width: 12),
                _buildStatCard(context, 'Total Paid', '\$75', Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveLockInsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Lock-Ins',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.fitness_center, color: Colors.white),
              ),
              title: const Text('Daily Workout'),
              subtitle: const Text('Day 15 of 30'),
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
              subtitle: const Text('Day 7 of 14'),
              trailing: const Text('Active', style: TextStyle(color: Colors.green)),
              onTap: () {
                context.go('/lock-in/reading-456');
              },
            ),
            
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  context.go('/home');
                },
                child: const Text('View All'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAchievementBadge('First Lock-In', Icons.star, Colors.yellow),
                _buildAchievementBadge('5 Day Streak', Icons.local_fire_department, Colors.orange),
                _buildAchievementBadge('Fitness Enthusiast', Icons.fitness_center, Colors.green),
                _buildAchievementBadge('Bookworm', Icons.book, Colors.blue),
                _buildAchievementBadge('Coming Soon', Icons.lock, Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(String title, IconData icon, Color color) {
    final isUnlocked = color != Colors.grey;
    
    return Chip(
      avatar: Icon(
        icon,
        color: isUnlocked ? color : Colors.grey,
        size: 16,
      ),
      label: Text(
        title,
        style: TextStyle(
          color: isUnlocked ? Colors.black : Colors.grey,
          fontSize: 12,
        ),
      ),
      backgroundColor: isUnlocked ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              subtitle: const Text('Manage your notification preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to notifications settings
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy'),
              subtitle: const Text('Control your privacy settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to privacy settings
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              subtitle: const Text('Get help and contact support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to help
              },
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(User? user) {
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!.split(' ').map((name) => name[0]).join().toUpperCase();
    }
    return user?.email?.substring(0, 2).toUpperCase() ?? 'U';
  }

  void _saveProfile() {
    // Here would normally save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    setState(() {
      _isEditing = false;
    });
  }
}