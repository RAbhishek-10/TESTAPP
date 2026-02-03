import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_error_state.dart';
import '../../../core/widgets/section_card.dart';

class LiveClassesScreen extends StatelessWidget {
  const LiveClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // When live data exists, use _buildWithSections for "Live now" / "Upcoming" sections.
    const hasLiveData = false;
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text("Live Classes", style: AppTheme.titleStyle),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
      ),
      // ignore: dead_code
      body: hasLiveData ? _buildWithSections(context) : _buildEmptyWithSearch(),
    );
  }

  Widget _buildEmptyWithSearch() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.bgLight,
                borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                border: Border.all(color: AppTheme.textGrey.withOpacity(0.2)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textGrey, size: 22),
                  hintText: "Search live classes...",
                  hintStyle: AppTheme.captionStyle,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyErrorState(
            message: 'No live classes right now',
            subtitle: 'Schedule and join live streams here. We\'ll notify you when a class starts.',
            icon: Icons.live_tv_rounded,
            actionLabel: 'View schedule',
            onRetry: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildWithSections(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.bgLight,
                borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                border: Border.all(color: AppTheme.textGrey.withOpacity(0.2)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textGrey, size: 22),
                  hintText: "Search live classes...",
                  hintStyle: AppTheme.captionStyle,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text("Live now", style: AppTheme.titleStyle.copyWith(fontSize: 18)),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 0,
              itemBuilder: (context, index) => const SizedBox(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text("Upcoming", style: AppTheme.titleStyle.copyWith(fontSize: 18)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SectionCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No upcoming classes',
                      style: AppTheme.captionStyle,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
