import 'package:firebase_getset_userdata/firebase/firebase_constant.dart';

class User {
  // methods
  static Future<bool> setUserData(
      {required String name, required int age, required String gender}) async {
    try {
      await FirebaseManager.db.collection("user").doc().set({
        "name": name,
        "age": age,
        "gender": gender,
      });
      return true;
    } catch (err) {
      return false;
    }
  }
}
