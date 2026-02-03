// Models for Profile Section

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final UserStats stats;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.stats,
  });
}

class UserStats {
  final int coursesEnrolled;
  final int testsTaken;
  final int hoursLearned;
  final int badges;

  UserStats({
    required this.coursesEnrolled,
    required this.testsTaken,
    required this.hoursLearned,
    required this.badges,
  });
}

class ProgressData {
  final List<DailyProgress> weeklyProgress;
  final Map<String, double> subjectAccuracy;
  final List<String> weakAreas;

  ProgressData({
    required this.weeklyProgress,
    required this.subjectAccuracy,
    required this.weakAreas,
  });
}

class DailyProgress {
  final DateTime date;
  final double score;

  DailyProgress({required this.date, required this.score});
}
