import 'package:firebase_getset_userdata/firebase/firebase_constant.dart';
import 'package:firebase_getset_userdata/firebase_options.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // readData();
    // return const Placeholder();
    return MaterialApp(
      home: SetScreen(),
    );
  }
}

void readData() async {
  await FirebaseManager.db.collection("user").get().then((snapshot) {
    for (var docSnapshot in snapshot.docs) {
      docSnapshot.reference.get().then((snapshot) {
        final data = snapshot.data();
        print("name : ${data?["name"] ?? "Error name"}");
        print("age : ${data?["age"] ?? "Error age"}");
        print("gender : ${data?["gender"] ?? "Error gender"}");
      });
    }
  });
}
