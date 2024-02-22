import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MainViewModel with ChangeNotifier {
  // Bottom Navigator
  late bool _showBottomTabs;
  bool get showBottomTabs => _showBottomTabs;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  late int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  MainViewModel() {
    _showBottomTabs = true;
    notifyListeners();
  }

  void onShowBottomTabsChanged(bool newValue) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _showBottomTabs = newValue;
    });
    notifyListeners();
  }

  void onItemTapped({required int index}) {
    _currentIndex = index;
    _navigatorKey.currentState?.popUntil((route) => route.isFirst);
    notifyListeners();
  }
}
