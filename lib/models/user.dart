class FeedItem {
  final String id;
  final String username;
  final String userAvatar;
  final String action;
  final String details;
  final DateTime timestamp;
  final FeedItemType type;
  final int likes;
  final int comments;

  FeedItem({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.action,
    required this.details,
    required this.timestamp,
    required this.type,
    this.likes = 0,
    this.comments = 0,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

enum FeedItemType {
  success,
  failure,
  milestone,
  start,
  complete,
}

class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final int totalLockIns;
  final int completedLockIns;
  final int currentStreak;
  final int longestStreak;
  final double totalPaid;
  final List<String> achievements;

  UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.bio,
    this.totalLockIns = 0,
    this.completedLockIns = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalPaid = 0.0,
    this.achievements = const [],
  });

  double get successRate {
    if (totalLockIns == 0) return 0.0;
    return (completedLockIns / totalLockIns) * 100;
  }

  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!.split(' ').map((name) => name[0]).join().toUpperCase();
    }
    return email.substring(0, 2).toUpperCase();
  }
}