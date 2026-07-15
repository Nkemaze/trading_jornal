import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentBottomNavIndex = 0;
  bool _hasCompletedOnboarding = false;

  int get currentBottomNavIndex => _currentBottomNavIndex;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  void setBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    notifyListeners();
  }

  void completeOnboarding() {
    _hasCompletedOnboarding = true;
    notifyListeners();
  }
}
