import '../models/user.dart';

class FeedService {
  static List<FeedItem> getMockFeedItems() {
    return [
      FeedItem(
        id: '1',
        username: 'alex_fit',
        userAvatar: '',
        action: 'completed their workout lock-in',
        details: 'Day 15/30 - Still going strong! 💪',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: FeedItemType.success,
        likes: 12,
        comments: 3,
      ),
      FeedItem(
        id: '2',
        username: 'bookworm_sarah',
        userAvatar: '',
        action: 'started a new reading challenge',
        details: 'Reading 1 book per week for the next 12 weeks 📚',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        type: FeedItemType.start,
        likes: 8,
        comments: 5,
      ),
      FeedItem(
        id: '3',
        username: 'mike_coder',
        userAvatar: '',
        action: 'missed their coding practice',
        details: 'Punishment: \$5 donated to charity 😅',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        type: FeedItemType.failure,
        likes: 2,
        comments: 1,
      ),
      FeedItem(
        id: '4',
        username: 'yoga_jenny',
        userAvatar: '',
        action: 'achieved a 7-day streak',
        details: 'Morning yoga every day this week! 🧘‍♀️',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: FeedItemType.milestone,
        likes: 24,
        comments: 8,
      ),
    ];
  }

  static Future<List<FeedItem>> fetchFeed({
    String filter = 'all',
    int page = 1,
    int limit = 20,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    var items = getMockFeedItems();
    
    // Apply filter
    switch (filter.toLowerCase()) {
      case 'following':
        // In a real app, this would filter by followed users
        items = items.take(2).toList();
        break;
      case 'trending':
        // Sort by likes + comments
        items.sort((a, b) => (b.likes + b.comments).compareTo(a.likes + a.comments));
        break;
      default:
        // Return all items
        break;
    }
    
    return items;
  }

  static Future<bool> likeFeedItem(String itemId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  static Future<bool> commentOnFeedItem(String itemId, String comment) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}