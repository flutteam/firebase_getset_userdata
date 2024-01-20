import 'package:firebase_getset_userdata/firebase_options.dart';
import 'package:firebase_getset_userdata/get_data/get_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const GetScreen(),
    SetScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        // bottom navigation 선언
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '유저 리스트',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '유저 생성',
            ),
          ],
          currentIndex: _selectedIndex, // 지정 인덱스로 이동
          selectedItemColor: Colors.lightGreen,
          onTap: _onItemTapped, // 선언했던 onItemTapped
        ),
      ),
    );
  }
}
