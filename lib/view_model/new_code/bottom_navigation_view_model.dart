import 'package:flutter/material.dart';

class BottomNavigationViewModel with ChangeNotifier {
  // MARK: - States
  int _index = 0;
  int get currentPage => _index;

  // MARK: - Methods
  updateCurrentPage(int index) {
    _index = index;
    notifyListeners();
  }
}
