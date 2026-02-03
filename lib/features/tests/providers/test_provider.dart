import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/test_models.dart';

// Available tests provider
final testsProvider = FutureProvider<List<TestModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  
  return [
    TestModel(
      id: 't1',
      title: 'JEE Main Mock Test 2024',
      category: 'Mock Test',
      duration: 180,
      totalQuestions: 90,
      difficulty: 'Hard',
    ),
    TestModel(
      id: 't2',
      title: 'Physics Chapter 1 Quiz',
      category: 'Daily Quiz',
      duration: 15,
      totalQuestions: 10,
      difficulty: 'Easy',
    ),
    TestModel(
      id: 't3',
      title: 'NEET Biology PYQ 2023',
      category: 'PYQ',
      duration: 60,
      totalQuestions: 45,
      difficulty: 'Medium',
      isAttempted: true,
    ),
    TestModel(
      id: 't4',
      title: 'Mathematics Daily Practice',
      category: 'Daily Quiz',
      duration: 20,
      totalQuestions: 15,
      difficulty: 'Medium',
    ),
  ];
});

// Test questions provider (family)
final testQuestionsProvider = FutureProvider.family<List<QuestionModel>, String>((ref, testId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  // Mock questions
  return List.generate(10, (index) {
    return QuestionModel(
      id: 'q${index + 1}',
      questionText: 'Question ${index + 1}: What is the value of x in the equation 2x + 5 = 15?',
      options: ['5', '10', '15', '20'],
      correctAnswer: 0,
      explanation: 'Solving: 2x + 5 = 15\n2x = 10\nx = 5',
    );
  });
});

// Current test attempt state
final testAttemptProvider = NotifierProvider<TestAttemptNotifier, TestAttempt?>(TestAttemptNotifier.new);

class TestAttemptNotifier extends Notifier<TestAttempt?> {
  @override
  TestAttempt? build() => null;

  void startTest(String testId, int totalQuestions, int durationMinutes) {
    state = TestAttempt(
      testId: testId,
      selectedAnswers: List.filled(totalQuestions, null),
      markedForReview: List.filled(totalQuestions, false),
      startTime: DateTime.now(),
      timeRemaining: durationMinutes * 60,
    );
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    if (state == null) return;
    final newAnswers = List<int?>.from(state!.selectedAnswers);
    newAnswers[questionIndex] = answerIndex;
    state = state!.copyWith(selectedAnswers: newAnswers);
  }

  void clearAnswer(int questionIndex) {
    if (state == null) return;
    final newAnswers = List<int?>.from(state!.selectedAnswers);
    newAnswers[questionIndex] = null;
    state = state!.copyWith(selectedAnswers: newAnswers);
  }

  void toggleMarkForReview(int questionIndex) {
    if (state == null) return;
    final newMarked = List<bool>.from(state!.markedForReview);
    newMarked[questionIndex] = !newMarked[questionIndex];
    state = state!.copyWith(markedForReview: newMarked);
  }

  void goToQuestion(int index) {
    if (state == null) return;
    state = state!.copyWith(currentQuestionIndex: index);
  }

  void nextQuestion() {
    if (state == null) return;
    if (state!.currentQuestionIndex < state!.selectedAnswers.length - 1) {
      state = state!.copyWith(currentQuestionIndex: state!.currentQuestionIndex + 1);
    }
  }

  void previousQuestion() {
    if (state == null) return;
    if (state!.currentQuestionIndex > 0) {
      state = state!.copyWith(currentQuestionIndex: state!.currentQuestionIndex - 1);
    }
  }

  void updateTime(int seconds) {
    if (state == null) return;
    state = state!.copyWith(timeRemaining: seconds);
  }

  TestResult submitTest(List<QuestionModel> questions) {
    if (state == null) {
      throw Exception('No active test');
    }

    int correct = 0;
    int wrong = 0;
    int unattempted = 0;

    for (int i = 0; i < questions.length; i++) {
      if (state!.selectedAnswers[i] == null) {
        unattempted++;
      } else if (state!.selectedAnswers[i] == questions[i].correctAnswer) {
        correct++;
      } else {
        wrong++;
      }
    }

    final timeTaken = DateTime.now().difference(state!.startTime).inSeconds;
    final percentage = (correct / questions.length) * 100;

    final result = TestResult(
      testId: state!.testId,
      score: correct * 4 - wrong, // +4 for correct, -1 for wrong
      correct: correct,
      wrong: wrong,
      unattempted: unattempted,
      timeTaken: timeTaken,
      rank: 1250, // Mock rank
      percentage: percentage,
    );

    state = null; // Clear attempt
    return result;
  }

  void endTest() {
    state = null;
  }
}

