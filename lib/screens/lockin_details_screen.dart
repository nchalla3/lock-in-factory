import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LockInDetailsScreen extends StatelessWidget {
  final String lockInId;
  
  const LockInDetailsScreen({super.key, required this.lockInId});

  @override
  Widget build(BuildContext context) {
    // Mock data - would normally fetch from backend based on lockInId
    final lockIn = _getMockLockInData();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  lockIn['title'],
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Status Card
          Card(
            color: lockIn['isActive'] ? Colors.green.shade50 : Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    lockIn['isActive'] ? Icons.check_circle : Icons.cancel,
                    color: lockIn['isActive'] ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lockIn['isActive'] ? 'Active' : 'Failed',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: lockIn['isActive'] ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                        'Day ${lockIn['currentDay']} of ${lockIn['totalDays']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (lockIn['isActive'])
                    ElevatedButton(
                      onPressed: () => _checkIn(context),
                      child: const Text('Check In'),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Progress Section
          _buildProgressSection(context, lockIn),
          
          const SizedBox(height: 16),
          
          // Details Section
          _buildDetailsSection(context, lockIn),
          
          const SizedBox(height: 16),
          
          // Punishment Section
          _buildPunishmentSection(context, lockIn),
          
          const SizedBox(height: 16),
          
          // Activity Log
          _buildActivityLog(context, lockIn),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, Map<String, dynamic> lockIn) {
    double progress = lockIn['currentDay'] / lockIn['totalDays'];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                lockIn['isActive'] ? Colors.green : Colors.red,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(progress * 100).toStringAsFixed(1)}% Complete'),
                Text('${lockIn['totalDays'] - lockIn['currentDay']} days remaining'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                _buildStatCard(context, 'Streak', '${lockIn['streak']} days', Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard(context, 'Success Rate', '${lockIn['successRate']}%', Colors.green),
                const SizedBox(width: 12),
                _buildStatCard(context, 'Missed', '${lockIn['missed']}', Colors.orange),
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
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, Map<String, dynamic> lockIn) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            _buildDetailRow('Category', lockIn['category']),
            _buildDetailRow('Frequency', lockIn['frequency']),
            _buildDetailRow('Start Date', lockIn['startDate']),
            _buildDetailRow('End Date', lockIn['endDate']),
            
            if (lockIn['description'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(lockIn['description']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPunishmentSection(BuildContext context, Map<String, dynamic> lockIn) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Punishment Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            _buildDetailRow('Amount', '\$${lockIn['punishmentAmount']}'),
            _buildDetailRow('Beneficiary', lockIn['punishmentBeneficiary']),
            _buildDetailRow('Times Triggered', '${lockIn['punishmentTriggered']}'),
            
            if (lockIn['punishmentTriggered'] > 0)
              Text(
                'Total paid: \$${lockIn['punishmentAmount'] * lockIn['punishmentTriggered']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLog(BuildContext context, Map<String, dynamic> lockIn) {
    final activities = lockIn['activities'] as List<Map<String, dynamic>>;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Log',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            ...activities.map((activity) => ListTile(
              leading: Icon(
                activity['success'] ? Icons.check_circle : Icons.cancel,
                color: activity['success'] ? Colors.green : Colors.red,
              ),
              title: Text(activity['action']),
              subtitle: Text(activity['date']),
              trailing: activity['note'] != null
                  ? IconButton(
                      icon: const Icon(Icons.note),
                      onPressed: () => _showNote(context, activity['note']),
                    )
                  : null,
            )),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getMockLockInData() {
    return {
      'title': 'Daily 30-minute workout',
      'category': 'Fitness',
      'description': 'Complete at least 30 minutes of physical exercise every day',
      'frequency': 'Daily',
      'startDate': 'Jan 1, 2024',
      'endDate': 'Jan 30, 2024',
      'totalDays': 30,
      'currentDay': 15,
      'isActive': true,
      'streak': 12,
      'successRate': 80,
      'missed': 3,
      'punishmentAmount': 25,
      'punishmentBeneficiary': 'American Red Cross',
      'punishmentTriggered': 1,
      'activities': [
        {
          'action': 'Checked in successfully',
          'date': 'Today, 7:30 AM',
          'success': true,
          'note': 'Great cardio session!',
        },
        {
          'action': 'Missed check-in - Punishment triggered',
          'date': 'Yesterday',
          'success': false,
          'note': 'Was traveling, forgot to work out',
        },
        {
          'action': 'Checked in successfully',
          'date': '2 days ago',
          'success': true,
          'note': null,
        },
      ],
    };
  }

  void _checkIn(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checked in successfully! Keep it up!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showNote(BuildContext context, String note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Note'),
        content: Text(note),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}