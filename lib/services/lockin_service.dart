import '../models/lockin.dart';
import '../models/user.dart';

class LockInService {
  // Mock data service - in a real app, this would connect to Firebase/backend
  
  static List<LockIn> getMockActiveLockIns() {
    return [
      LockIn(
        id: 'workout-123',
        title: 'Daily Workout',
        description: 'Complete at least 30 minutes of physical exercise every day',
        category: 'Fitness',
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        endDate: DateTime.now().add(const Duration(days: 27)),
        totalDays: 30,
        currentDay: 3,
        frequency: 'Daily',
        isActive: true,
        punishmentAmount: 25.0,
        punishmentBeneficiary: 'American Red Cross',
        streak: 3,
        successRate: 100.0,
        missedDays: 0,
      ),
      LockIn(
        id: 'reading-456',
        title: 'Read for 1 hour',
        description: 'Read books for at least 1 hour every day',
        category: 'Learning',
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 7)),
        totalDays: 14,
        currentDay: 7,
        frequency: 'Daily',
        isActive: true,
        punishmentAmount: 15.0,
        punishmentBeneficiary: 'Local Library',
        streak: 5,
        successRate: 85.7,
        missedDays: 1,
      ),
    ];
  }

  static LockIn? getLockInById(String id) {
    final lockIns = getMockActiveLockIns();
    try {
      return lockIns.firstWhere((lockIn) => lockIn.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<LockIn>> fetchUserLockIns(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockActiveLockIns();
  }

  static Future<LockIn> createLockIn({
    required String title,
    required String description,
    required String category,
    required int duration,
    required String frequency,
    required double punishmentAmount,
    String? punishmentBeneficiary,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final now = DateTime.now();
    return LockIn(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      startDate: now,
      endDate: now.add(Duration(days: duration)),
      totalDays: duration,
      currentDay: 0,
      frequency: frequency,
      isActive: true,
      punishmentAmount: punishmentAmount,
      punishmentBeneficiary: punishmentBeneficiary ?? 'Default Charity',
      streak: 0,
      successRate: 100.0,
      missedDays: 0,
    );
  }

  static Future<bool> checkIn(String lockInId, {String? note}) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Success
  }
}