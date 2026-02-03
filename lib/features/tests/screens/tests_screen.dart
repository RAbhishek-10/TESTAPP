import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/test_provider.dart';
import '../models/test_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_error_state.dart';

class TestsScreen extends ConsumerStatefulWidget {
  const TestsScreen({super.key});

  @override
  ConsumerState<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends ConsumerState<TestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testsAsync = ref.watch(testsProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text("Tests & Practice", style: AppTheme.titleStyle),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textGrey,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppTheme.captionStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryBlue,
          ),
          unselectedLabelStyle: AppTheme.captionStyle,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Mock"),
            Tab(text: "PYQs"),
            Tab(text: "Quiz"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Premium Search & Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.bgLight,
                      borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                      border: Border.all(color: AppTheme.textGrey.withOpacity(0.2)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textGrey, size: 20),
                        hintText: "Search tests...",
                        hintStyle: AppTheme.captionStyle,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppTheme.primaryBlue, size: 20),
                ),
              ],
            ),
          ),

          // Daily Challenge Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(Icons.stars, size: 150, color: Colors.white.withOpacity(0.1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "🔥 DAILY STREAK",
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Practice Daily Quiz",
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Win up to 50 GC coins today!",
                                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.push('/test/t2/take'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text("Start Now", style: AppTheme.captionStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tests Grid
          Expanded(
            child: testsAsync.when(
              data: (tests) => TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildTestGrid(tests),
                  _buildTestGrid(tests.where((t) => t.category == 'Mock Test').toList()),
                  _buildTestGrid(tests.where((t) => t.category == 'PYQ').toList()),
                  _buildTestGrid(tests.where((t) => t.category == 'Daily Quiz').toList()),
                ],
              ),
              loading: () => _buildShimmerGrid(),
              error: (err, stack) => EmptyErrorState(
                message: 'Couldn\'t load tests',
                subtitle: 'Check your connection and try again.',
                icon: Icons.quiz_outlined,
                onRetry: () => ref.invalidate(testsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestGrid(List<TestModel> tests) {
    if (tests.isEmpty) {
      return EmptyErrorState(
        message: 'No tests in this category',
        subtitle: 'Try another tab or check back later.',
        icon: Icons.quiz_outlined,
        actionLabel: 'View All',
        onRetry: () {},
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: tests.length,
      itemBuilder: (context, index) => _TestCard(test: tests[index]),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: AppTheme.textGrey.withOpacity(0.2),
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
        ),
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  final TestModel test;
  const _TestCard({required this.test});

  @override
  Widget build(BuildContext context) {
    final Gradient cardGradient = test.category == 'Mock Test'
        ? const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)])
        : test.category == 'PYQ'
            ? const LinearGradient(colors: [Color(0xFFFB923C), Color(0xFFF97316)])
            : const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)]);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.cardShadowList,
        border: Border.all(color: AppTheme.textGrey.withOpacity(0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/test/${test.id}/take'),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: cardGradient,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
                ),
                child: Stack(
                  children: [
                    if (test.isAttempted)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.green, size: 12),
                        ),
                      ),
                    Center(
                      child: Icon(
                        test.category == 'Mock Test'
                            ? Icons.assignment
                            : test.category == 'PYQ'
                                ? Icons.history
                                : Icons.flash_on,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _StatChip(icon: Icons.timer_outlined, label: '${test.duration}m'),
                          const SizedBox(width: 8),
                          _StatChip(icon: Icons.help_outline, label: '${test.totalQuestions}Q'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppTheme.textGrey),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTheme.captionStyle.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
