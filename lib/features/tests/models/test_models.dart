// Models for Tests Section

class TestModel {
  final String id;
  final String title;
  final String category; // Mock, PYQ, Daily Quiz
  final int duration; // in minutes
  final int totalQuestions;
  final String difficulty;
  final bool isAttempted;

  TestModel({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.totalQuestions,
    required this.difficulty,
    this.isAttempted = false,
  });
}

class QuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswer; // 0-3 index
  final String? explanation;
  final String? imageUrl;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.imageUrl,
  });
}

class TestAttempt {
  final String testId;
  final List<int?> selectedAnswers; // null = unattempted
  final List<bool> markedForReview;
  final int currentQuestionIndex;
  final DateTime startTime;
  final int timeRemaining; // in seconds

  TestAttempt({
    required this.testId,
    required this.selectedAnswers,
    required this.markedForReview,
    this.currentQuestionIndex = 0,
    required this.startTime,
    required this.timeRemaining,
  });

  TestAttempt copyWith({
    int? currentQuestionIndex,
    List<int?>? selectedAnswers,
    List<bool>? markedForReview,
    int? timeRemaining,
  }) {
    return TestAttempt(
      testId: testId,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      markedForReview: markedForReview ?? this.markedForReview,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      startTime: startTime,
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }
}

class TestResult {
  final String testId;
  final int score;
  final int correct;
  final int wrong;
  final int unattempted;
  final int timeTaken; // in seconds
  final int rank;
  final double percentage;

  TestResult({
    required this.testId,
    required this.score,
    required this.correct,
    required this.wrong,
    required this.unattempted,
    required this.timeTaken,
    required this.rank,
    required this.percentage,
  });
}
