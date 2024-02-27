import 'package:firebase_getset_userdata/view/get_user_data_view/get_user_data_view.dart';
import 'package:firebase_getset_userdata/view/set_user_data_view/set_user_data_view.dart';
import 'package:firebase_getset_userdata/view_model/new_code/bottom_navigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BottomNavigationView extends StatelessWidget {
  late BottomNavigationViewModel _bottomNavigationViewModel;

  BottomNavigationView({super.key});

  Widget _navigationBody() {
    switch (_bottomNavigationViewModel.currentPage) {
      case 0:
        return const GetUserDataView();

      case 1:
        return SetUserDataView();
    }
    return Container();
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "유저 리스트"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "유저 추가")
      ],
      currentIndex: _bottomNavigationViewModel.currentPage,
      selectedItemColor: Colors.blue,
      onTap: (index) {
        _bottomNavigationViewModel.updateCurrentPage(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provider를 호출해 접근
    _bottomNavigationViewModel =
        Provider.of<BottomNavigationViewModel>(context);

    return Scaffold(
      body: _navigationBody(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
