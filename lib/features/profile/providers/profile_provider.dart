import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';

// User Profile Provider
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  
  return UserProfile(
    id: 'user1',
    name: 'Abhishek Kumar',
    email: 'abhishek@example.com',
    phone: '+91 9876543210',
    avatarUrl: 'https://via.placeholder.com/150/0D47A1/FFFFFF?text=AK',
    stats: UserStats(
      coursesEnrolled: 12,
      testsTaken: 45,
      hoursLearned: 127,
      badges: 8,
    ),
  );
});

// Progress Data Provider
final progressDataProvider = FutureProvider<ProgressData>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  
  final now = DateTime.now();
  return ProgressData(
    weeklyProgress: List.generate(7, (index) {
      return DailyProgress(
        date: now.subtract(Duration(days: 6 - index)),
        score: 60 + (index * 5) + (index % 2 == 0 ? 10 : 0).toDouble(),
      );
    }),
    subjectAccuracy: {
      'Physics': 85.0,
      'Chemistry': 72.0,
      'Mathematics': 91.0,
      'Biology': 68.0,
    },
    weakAreas: [
      'Organic Chemistry',
      'Thermodynamics',
      'Calculus',
    ],
  );
});

// Settings State Providers (Using Notifier to replace StateProvider if it's missing)
final darkModeProvider = NotifierProvider<DarkModeNotifier, bool>(DarkModeNotifier.new);
class DarkModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle(bool value) => state = value;
}

final notificationsProvider = NotifierProvider<NotificationsNotifier, bool>(NotificationsNotifier.new);
class NotificationsNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle(bool value) => state = value;
}

final languageProvider = NotifierProvider<LanguageNotifier, String>(LanguageNotifier.new);
class LanguageNotifier extends Notifier<String> {
  @override
  String build() => 'English';
  void setLanguage(String lang) => state = lang;
}

final downloadQualityProvider = NotifierProvider<DownloadQualityNotifier, String>(DownloadQualityNotifier.new);
class DownloadQualityNotifier extends Notifier<String> {
  @override
  String build() => 'High';
  void setQuality(String quality) => state = quality;
}
