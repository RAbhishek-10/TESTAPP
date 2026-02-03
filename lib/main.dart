import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Safe Firebase Init
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init failed (expected if missing config): $e");
  }

  runApp(
    const ProviderScope(
      child: EduGuruApp(),
    ),
  );
}

class EduGuruApp extends ConsumerWidget {
  const EduGuruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'EduGuru',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Uses device system setting
      routerConfig: appRouter,
    );
  }
}
