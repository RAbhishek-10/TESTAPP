import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Subtle branded top bar (LIIVE3-style "one app" feel)
          Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: AppTheme.textGrey.withOpacity(0.1)),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Text(
                    'EduGuru',
                    style: AppTheme.titleStyle.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
            child: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
              elevation: AppTheme.navBarElevation,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppTheme.primaryBlue,
              unselectedItemColor: AppTheme.textGrey,
              selectedLabelStyle: AppTheme.captionStyle.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: AppTheme.primaryBlue,
              ),
              unselectedLabelStyle: AppTheme.captionStyle.copyWith(fontSize: 11),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 24),
                  activeIcon: Icon(Icons.home_rounded, size: 24),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_stories_outlined, size: 24),
                  activeIcon: Icon(Icons.auto_stories_rounded, size: 24),
                  label: 'Courses',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.quiz_outlined, size: 24),
                  activeIcon: Icon(Icons.quiz_rounded, size: 24),
                  label: 'Tests',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv_outlined, size: 24),
                  activeIcon: Icon(Icons.live_tv_rounded, size: 24),
                  label: 'Live',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded, size: 24),
                  activeIcon: Icon(Icons.person_rounded, size: 24),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
