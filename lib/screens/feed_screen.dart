import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Feed',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          
          // Filter tabs
          Row(
            children: [
              _buildFilterChip('All', true),
              const SizedBox(width: 8),
              _buildFilterChip('Following', false),
              const SizedBox(width: 8),
              _buildFilterChip('Trending', false),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Feed items
          Expanded(
            child: ListView(
              children: [
                _buildFeedItem(
                  context,
                  username: 'alex_fit',
                  action: 'completed their workout lock-in',
                  timeAgo: '2 hours ago',
                  details: 'Day 15/30 - Still going strong! 💪',
                  isSuccess: true,
                ),
                _buildFeedItem(
                  context,
                  username: 'bookworm_sarah',
                  action: 'started a new reading challenge',
                  timeAgo: '4 hours ago',
                  details: 'Reading 1 book per week for the next 12 weeks 📚',
                  isSuccess: null,
                ),
                _buildFeedItem(
                  context,
                  username: 'mike_coder',
                  action: 'missed their coding practice',
                  timeAgo: '6 hours ago',
                  details: 'Punishment: $5 donated to charity 😅',
                  isSuccess: false,
                ),
                _buildFeedItem(
                  context,
                  username: 'yoga_jenny',
                  action: 'achieved a 7-day streak',
                  timeAgo: '1 day ago',
                  details: 'Morning yoga every day this week! 🧘‍♀️',
                  isSuccess: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Filter logic would go here
      },
    );
  }

  Widget _buildFeedItem(
    BuildContext context, {
    required String username,
    required String action,
    required String timeAgo,
    required String details,
    bool? isSuccess, // true for success, false for failure, null for neutral
  }) {
    Color? statusColor;
    IconData? statusIcon;
    
    if (isSuccess == true) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isSuccess == false) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(username[0].toUpperCase()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' $action'),
                          ],
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (statusIcon != null)
                  Icon(statusIcon, color: statusColor, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              details,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up, size: 16),
                  label: const Text('Like'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.comment, size: 16),
                  label: const Text('Comment'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}