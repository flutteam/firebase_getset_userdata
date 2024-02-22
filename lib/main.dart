import 'package:firebase_getset_userdata/service/remote_service/firebase/firebase_options.dart';
import 'package:firebase_getset_userdata/view/get_user_data_view/get_user_data_view.dart';
import 'package:firebase_getset_userdata/view/main_view/main_view.dart';
import 'package:firebase_getset_userdata/view/set_user_data_view/set_user_data_view.dart';
import 'package:firebase_getset_userdata/view_model/main_view_model.dart';
import 'package:firebase_getset_userdata/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final pages = [
      MultiProvider(providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => MainViewModel()),
        ChangeNotifierProvider(
            create: (BuildContext context) => UserViewModel()),
      ], child: const GetUserDataView()),
      SetUserDataView(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<MainViewModel>(
        create: (context) => MainViewModel(),
        child: MainView(pages: pages),
      ),
    );
  }
}
