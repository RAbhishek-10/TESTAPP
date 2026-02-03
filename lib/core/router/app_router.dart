import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/courses/screens/courses_screen.dart';
import '../../features/courses/screens/course_detail_screen.dart';
import '../../features/courses/screens/lesson_player_screen.dart';
import '../../features/tests/screens/tests_screen.dart';
import '../../features/tests/screens/test_taking_screen.dart';
import '../../features/tests/screens/test_result_screen.dart';
import '../../features/live/screens/live_classes_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/progress_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/tests/models/test_models.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Splash
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // Auth
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phoneNumber = state.extra as String? ?? "";
        return OtpVerificationScreen(phoneNumber: phoneNumber);
      },
    ),
    // Dashboard Shell (Bottom Nav)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/courses',
              builder: (context, state) => const CoursesScreen(),
              routes: [
                GoRoute(
                  path: ':courseId',
                  builder: (context, state) => CourseDetailScreen(
                    courseId: state.pathParameters['courseId']!,
                  ),
                  routes: [
                    GoRoute(
                       path: 'lesson/:lessonId',
                       builder: (context, state) => LessonPlayerScreen(
                         courseId: state.pathParameters['courseId']!,
                         lessonId: state.pathParameters['lessonId']!,
                       ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tests',
              builder: (context, state) => const TestsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/live',
              builder: (context, state) => const LiveClassesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Test Taking & Result (Full Screen - outside shell)
    GoRoute(
      path: '/test/:testId/take',
      builder: (context, state) => TestTakingScreen(
        testId: state.pathParameters['testId']!,
      ),
    ),
    GoRoute(
      path: '/test/:testId/result',
      builder: (context, state) {
        final result = state.extra as TestResult;
        return TestResultScreen(
          testId: state.pathParameters['testId']!,
          result: result,
        );
      },
    ),
    // Profile routes (Full Screen - outside shell)
    GoRoute(
      path: '/profile/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/profile/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
