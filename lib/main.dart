import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_getset_userdata/service/remote_service/firebase/firebase_options.dart';
import 'package:firebase_getset_userdata/view/bottom_navigation_view/bottom_navigation_view.dart';
import 'package:firebase_getset_userdata/view_model/new_code/bottom_navigation_view_model.dart';
import 'package:firebase_getset_userdata/view_model/new_code/get_user_data_view_model.dart';
import 'package:firebase_getset_userdata/view_model/new_code/set_user_data_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => BottomNavigationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => GetUserDataViewModel(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => SetUserDataViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationView(),
    );
  }
}
