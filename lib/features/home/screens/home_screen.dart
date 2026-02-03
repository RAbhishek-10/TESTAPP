import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_error_state.dart';
import '../providers/home_provider.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: homeDataAsync.when(
        data: (data) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Premium Header with User Info
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.1,
                titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                background: Container(
                  color: Colors.white,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good Morning,",
                                style: AppTheme.captionStyle,
                              ),
                              Text(
                                "Abhishek Kumar",
                                style: AppTheme.titleStyle.copyWith(fontSize: 22),
                              ),
                            ],
                          ),
                          Spacer(),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppTheme.primaryBlue,
                            child: Text("AK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Hero(
                    tag: 'home_search',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(16),
                          child: Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.bgLight,
                            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                            border: Border.all(color: AppTheme.textGrey.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded, color: AppTheme.textGrey, size: 22),
                              const SizedBox(width: 12),
                              Text(
                                "Search for courses, tests, educators...",
                                style: AppTheme.captionStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content Body
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeBannerCarousel(banners: data.banners),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Quick Actions", style: AppTheme.titleStyle.copyWith(fontSize: 18)),
                    ),
                    const SizedBox(height: 16),
                    const QuickActionsGrid(),
                    const SizedBox(height: 24),
                    if (data.continueLearning.isNotEmpty) ...[
                      SectionHeader(title: "Continue Learning", onViewAll: () {}),
                      HorizontalCourseList(courses: data.continueLearning),
                      const SizedBox(height: 24),
                    ],
                    SectionHeader(title: "Top Educators", onViewAll: () {}),
                    EducatorList(educators: data.topEducators),
                    const SizedBox(height: 24),
                    SectionHeader(title: "Recommended for You", onViewAll: () {}),
                    HorizontalCourseList(courses: data.recommendedCourses),
                    const SizedBox(height: 24),
                    SectionHeader(title: "Popular Tests", onViewAll: () {}),
                    HorizontalCourseList(courses: data.popularTests),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const HomeShimmer(),
        error: (err, stack) => EmptyErrorState(
          message: 'Couldn\'t load content',
          subtitle: 'Pull down to refresh or try again later.',
          icon: Icons.wifi_off_rounded,
          onRetry: () => ref.invalidate(homeProvider),
        ),
      ),
    );
  }
}
