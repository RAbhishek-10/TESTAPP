import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/profile_provider.dart';
import '../../home/providers/home_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_error_state.dart';
import '../../../core/widgets/stat_chip.dart';
import '../../../core/widgets/section_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final homeDataAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: profileAsync.when(
        data: (profile) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Premium Header
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: AppTheme.primaryBlue,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white24,
                            ),
                            child: CircleAvatar(
                              radius: 54,
                              backgroundColor: Colors.white24,
                              backgroundImage: const NetworkImage('https://ui-avatars.com/api/?name=Abhishek&background=2563EB&color=fff'),
                              onBackgroundImageError: (_, __) {},
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Abhishek Kumar",
                            style: AppTheme.titleStyle.copyWith(color: Colors.white, fontSize: 24),
                          ),
                          Text(
                            "Standard XII • PCM Group",
                            style: AppTheme.captionStyle.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () => context.push('/profile/settings'),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.bgLight,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Overview Card (shared stat chips)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: SectionCard(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              StatChip(value: "12", label: "Courses", icon: Icons.menu_book_rounded, color: AppTheme.primaryBlue),
                              Container(height: 40, width: 1, color: AppTheme.textGrey.withOpacity(0.2)),
                              StatChip(value: "45", label: "Tests", icon: Icons.quiz_rounded, color: AppTheme.secondaryOrange),
                              Container(height: 40, width: 1, color: AppTheme.textGrey.withOpacity(0.2)),
                              StatChip(value: "82h", label: "Learning", icon: Icons.timer_rounded, color: Colors.green),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Continue Learning
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("In Progress Courses", style: AppTheme.titleStyle.copyWith(fontSize: 18)),
                      ),
                      const SizedBox(height: 16),
                      homeDataAsync.when(
                        data: (data) => SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: data.continueLearning.length,
                            itemBuilder: (context, index) {
                              final course = data.continueLearning[index];
                              return _CompactCourseCard(course: course);
                            },
                          ),
                        ),
                        loading: () => const SizedBox(height: 140, child: Center(child: CircularProgressIndicator())),
                        error: (_, __) => const SizedBox(),
                      ),

                      const SizedBox(height: 32),

                      // Achievements
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Achievements", style: AppTheme.titleStyle.copyWith(fontSize: 18)),
                            TextButton(
                              onPressed: () {},
                              child: Text("View All", style: AppTheme.captionStyle.copyWith(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                          children: [
                            _AchievementIcon(emoji: "🏆", label: "Top 1%", color: Colors.amber),
                            _AchievementIcon(emoji: "🔥", label: "Hot Streak", color: Colors.orange),
                            _AchievementIcon(emoji: "🎯", label: "Perfection", color: Colors.green),
                            _AchievementIcon(emoji: "💎", label: "Prime", color: Colors.cyan),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Menu Items
                      _buildProfileMenu(context),

                      const SizedBox(height: 40),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: OutlinedButton(
                          onPressed: () => _showLogoutDialog(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red.withOpacity(0.4)),
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                          ),
                          child: Text("Logout", style: AppTheme.captionStyle.copyWith(color: Colors.red, fontWeight: FontWeight.w700)),
                        ),
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primaryBlue),
          ),
        ),
        error: (err, stack) => EmptyErrorState(
          message: 'Couldn\'t load profile',
          subtitle: 'Pull down to refresh or try again.',
          icon: Icons.person_off_rounded,
          onRetry: () => ref.invalidate(userProfileProvider),
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Column(
      children: [
        _ProfileMenuItem(
          icon: Icons.analytics_rounded,
          title: "My Progress & Insights",
          subtitle: "Performance charts and accuracy",
          onTap: () => context.push('/profile/progress'),
        ),
        _ProfileMenuItem(
          icon: Icons.bookmark_rounded,
          title: "Saved Items",
          subtitle: "Courses, videos and questions",
          onTap: () {},
        ),
        _ProfileMenuItem(
          icon: Icons.history_rounded,
          title: "Order History",
          subtitle: "Course purchases and invoices",
          onTap: () {},
        ),
        _ProfileMenuItem(
          icon: Icons.help_center_rounded,
          title: "Support & FAQs",
          subtitle: "Need help? Contact us",
          onTap: () {},
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No, Cancel')),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Yes, Logout'),
          ),
        ],
      ),
    );
  }
}

class _CompactCourseCard extends StatelessWidget {
  final dynamic course;
  const _CompactCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.cardShadowList,
        border: Border.all(color: AppTheme.textGrey.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppTheme.cardRadius)),
            child: appCachedImage(
              imageUrl: course.imageUrl,
              width: 70,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(course.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTheme.captionStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: course.progress! / 100, minHeight: 4, color: AppTheme.primaryBlue, backgroundColor: AppTheme.bgLight),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementIcon extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _AchievementIcon({required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 28)),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTheme.captionStyle.copyWith(fontSize: 10)),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.cardShadowList,
        border: Border.all(color: AppTheme.textGrey.withOpacity(0.06)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
        ),
        title: Text(title, style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
        subtitle: Text(subtitle, style: AppTheme.captionStyle),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textGrey, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      ),
    );
  }
}
