import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/test_provider.dart';
import '../models/test_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_error_state.dart';

class TestTakingScreen extends ConsumerStatefulWidget {
  final String testId;
  const TestTakingScreen({super.key, required this.testId});

  @override
  ConsumerState<TestTakingScreen> createState() => _TestTakingScreenState();
}

class _TestTakingScreenState extends ConsumerState<TestTakingScreen> {
  Timer? _timer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startInitialTest();
    });
  }

  void _startInitialTest() {
    final tests = ref.read(testsProvider).value ?? [];
    final test = tests.firstWhere((t) => t.id == widget.testId);
    ref.read(testAttemptProvider.notifier).startTest(test.id, test.totalQuestions, test.duration);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final attempt = ref.read(testAttemptProvider);
      if (attempt != null && attempt.timeRemaining > 0) {
        ref.read(testAttemptProvider.notifier).updateTime(attempt.timeRemaining - 1);
      } else {
        _timer?.cancel();
        _autoSubmit();
      }
    });
  }

  void _autoSubmit() {
    _submitTest();
  }

  void _submitTest() {
    final questions = ref.read(testQuestionsProvider(widget.testId)).value ?? [];
    final result = ref.read(testAttemptProvider.notifier).submitTest(questions);
    context.pushReplacement('/test/${widget.testId}/result', extra: result);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(testQuestionsProvider(widget.testId));
    final attempt = ref.watch(testAttemptProvider);

    if (attempt == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        _showExitConfirmation();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: _buildQuestionDrawer(attempt, questionsAsync.value ?? []),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Physics Quiz 01", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              Text(
                "Question ${attempt.currentQuestionIndex + 1} of ${attempt.selectedAnswers.length}",
                style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: attempt.timeRemaining < 300 ? Colors.red.withOpacity(0.1) : AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 18,
                    color: attempt.timeRemaining < 300 ? Colors.red : AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(attempt.timeRemaining),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: attempt.timeRemaining < 300 ? Colors.red : AppTheme.primaryBlue,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.grid_view, color: AppTheme.textDark),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (attempt.currentQuestionIndex + 1) / attempt.selectedAnswers.length,
              backgroundColor: AppTheme.bgLight,
              color: AppTheme.primaryBlue,
              minHeight: 3,
            ),
            
            Expanded(
              child: questionsAsync.when(
                data: (questions) {
                  final question = questions[attempt.currentQuestionIndex];
                  final selectedAnswer = attempt.selectedAnswers[attempt.currentQuestionIndex];
                  final isMarked = attempt.markedForReview[attempt.currentQuestionIndex];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Tags
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.bgLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "SINGLE CHOICE",
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textGrey),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "+4 CORRECT",
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Question Text
                        Text(
                          question.questionText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Options
                        ...List.generate(question.options.length, (index) {
                          final isSelected = selectedAnswer == index;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () => ref.read(testAttemptProvider.notifier).selectAnswer(attempt.currentQuestionIndex, index),
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryBlue.withOpacity(0.05) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? AppTheme.primaryBlue : Colors.grey[200]!,
                                    width: isSelected ? 2 : 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppTheme.primaryBlue : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? AppTheme.primaryBlue : Colors.grey[300]!,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: isSelected 
                                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                                          : Text(
                                              String.fromCharCode(65 + index),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        question.options[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        
                        const SizedBox(height: 40),
                        
                        // Mark for Review & Clear
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => ref.read(testAttemptProvider.notifier).toggleMarkForReview(attempt.currentQuestionIndex),
                              icon: Icon(isMarked ? Icons.bookmark : Icons.bookmark_border, size: 20),
                              label: Text(isMarked ? "Marked" : "Mark for Review"),
                              style: TextButton.styleFrom(foregroundColor: isMarked ? Colors.orange : AppTheme.textGrey),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => ref.read(testAttemptProvider.notifier).clearAnswer(attempt.currentQuestionIndex),
                              icon: const Icon(Icons.refresh, size: 20),
                              label: const Text("Clear Selection"),
                              style: TextButton.styleFrom(foregroundColor: AppTheme.textGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => Center(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primaryBlue),
                  ),
                ),
                error: (err, stack) => EmptyErrorState(
                  message: 'Couldn\'t load test',
                  subtitle: 'Something went wrong. Try again.',
                  icon: Icons.quiz_outlined,
                  onRetry: () => ref.invalidate(testQuestionsProvider(widget.testId)),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(attempt),
      ),
    );
  }

  Widget _buildBottomNav(TestAttempt attempt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous
            if (attempt.currentQuestionIndex > 0)
              IconButton(
                onPressed: () => ref.read(testAttemptProvider.notifier).previousQuestion(),
                icon: const Icon(Icons.arrow_back_ios_new),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.bgLight,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            
            const SizedBox(width: 16),
            
            // Next or Submit
            Expanded(
              child: attempt.currentQuestionIndex < attempt.selectedAnswers.length - 1
                  ? ElevatedButton(
                      onPressed: () => ref.read(testAttemptProvider.notifier).nextQuestion(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        minimumSize: const Size.fromHeight(56),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Save & Next", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _showSubmitConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size.fromHeight(56),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("SUBMIT TEST", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionDrawer(TestAttempt attempt, List<QuestionModel> questions) {
    return Drawer(
      width: 320,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Question Navigator", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavigatorStat(
                    count: attempt.selectedAnswers.where((a) => a != null).length,
                    label: "Answered",
                    color: Colors.green,
                  ),
                  _NavigatorStat(
                    count: attempt.markedForReview.where((m) => m).length,
                    label: "Marked",
                    color: Colors.orange,
                  ),
                  _NavigatorStat(
                    count: attempt.selectedAnswers.where((a) => a == null).length,
                    label: "Not Visited",
                    color: Colors.grey[300]!,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              
              // Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: attempt.selectedAnswers.length,
                  itemBuilder: (context, index) {
                    final isAnswered = attempt.selectedAnswers[index] != null;
                    final isMarked = attempt.markedForReview[index];
                    final isCurrent = attempt.currentQuestionIndex == index;
                    
                    Color bgColor = Colors.white;
                    Color textColor = AppTheme.textDark;
                    Border? border = Border.all(color: Colors.grey[300]!);
                    
                    if (isCurrent) {
                      bgColor = AppTheme.primaryBlue;
                      textColor = Colors.white;
                      border = null;
                    } else if (isMarked) {
                      bgColor = Colors.orange;
                      textColor = Colors.white;
                      border = null;
                    } else if (isAnswered) {
                      bgColor = Colors.green;
                      textColor = Colors.white;
                      border = null;
                    }
                    
                    return InkWell(
                      onTap: () {
                        ref.read(testAttemptProvider.notifier).goToQuestion(index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: border,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Submit button in drawer
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showSubmitConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("SUBMIT TEST"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmation() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quit Test?'),
        content: const Text('Your current progress will be lost. Are you sure you want to end this test?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(testAttemptProvider.notifier).endTest();
              Navigator.pop(context, true);
            },
            child: const Text('Quit Test', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (shouldExit == true && mounted) {
      context.pop();
    }
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Submit Test?'),
        content: const Text('Are you sure you want to submit your answers? You won\'t be able to change them afterwards.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Review Again')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitTest();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Yes, Submit'),
          ),
        ],
      ),
    );
  }
}

class _NavigatorStat extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _NavigatorStat({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$count", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w600)),
      ],
    );
  }
}
