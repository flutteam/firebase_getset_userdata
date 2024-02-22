import 'package:firebase_getset_userdata/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({
    super.key,
    required this.pages,
  });

  final List<StatelessWidget> pages;

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          // body
          // Navigator로 body를 감싸주어 bottom Navigator가 페이지 이동을 해도 사라지지 않도록 함
          body: Navigator(
            // key 등록
            key: provider.navigatorKey,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) {
                  return pages[provider.currentIndex];
                },
              );
            },
          ),
          // bottom navigation
          bottomNavigationBar: provider.showBottomTabs
              ? BottomNavigationBar(
                  // 지정 인덱스로 이동
                  currentIndex: provider.currentIndex,
                  // 해당 index로 current Index 변경
                  onTap: (index) {
                    provider.onItemTapped(
                      index: index,
                    );
                  },
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                      ),
                      label: 'User List',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.people,
                      ),
                      label: 'Create User',
                    ),
                  ],
                  selectedItemColor: Colors.purple,
                )
              : null,
        );
      },
    );
  }
}
