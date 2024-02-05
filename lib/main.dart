import 'package:firebase_getset_userdata/firebase_options.dart';
import 'package:firebase_getset_userdata/get_data/get_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import './set_data/set_screen.dart';

void main() async {
  await initializeFirebase();
  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Navigator Key를 등록하여, Bottom Navigator의 탭이 이동할 때, 이전 탭의 page들을 모두 Pop 할 수 있게 함
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _showBottomTabs = true;
  int _currentIndex = 0;

  void _onItemTapped({required int index}) {
    setState(
      () {
        _currentIndex = index;
      },
    );
    _navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  void _updateShowBottomTabs(bool newValue) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _showBottomTabs = newValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      GetScreen(
          showBottomTabs: _showBottomTabs,
          onShowBottomTabsChanged: _updateShowBottomTabs),
      SetScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // body
        // Navigator로 body를 감싸주어 bottom Navigator가 페이지 이동을 해도 사라지지 않도록 함
        body: Navigator(
          // key 등록
          key: _navigatorKey,
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) {
                return pages[_currentIndex];
              },
            );
          },
        ),
        // bottom navigation
        bottomNavigationBar: _showBottomTabs
            ? BottomNavigationBar(
                // 지정 인덱스로 이동
                currentIndex: _currentIndex,
                // 해당 index로 current Index 변경
                onTap: (index) {
                  _onItemTapped(
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
      ),
    );
  }
}
