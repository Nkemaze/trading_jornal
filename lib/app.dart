import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_dashboard_screen.dart';

class ZenithApp extends StatelessWidget {
  const ZenithApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenith Trading Journal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const _AppFlow(),
    );
  }
}

class _AppFlow extends StatefulWidget {
  const _AppFlow();

  @override
  State<_AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<_AppFlow> {
  _AppStage _stage = _AppStage.splash;

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case _AppStage.splash:
        return SplashScreen(
          onComplete: () {
            setState(() => _stage = _AppStage.onboarding);
          },
        );
      case _AppStage.onboarding:
        return OnboardingScreen(
          onComplete: () {
            setState(() => _stage = _AppStage.dashboard);
          },
        );
      case _AppStage.dashboard:
        return const HomeDashboardScreen();
    }
  }
}

enum _AppStage {
  splash,
  onboarding,
  dashboard,
}
