import 'package:firebase_getset_userdata/firebase/firebase_constant.dart';

class GetModel {
  static Future<List<Map<String, dynamic>>> readData() async {
    List<Map<String, dynamic>> userDataList = [];

    await FirebaseManager.db.collection("user").get().then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        docSnapshot.reference.get().then((snapshot) {
          final data = snapshot.data();
          userDataList.add({
            "name": data?["name"] ?? "Error name",
            "age": data?["age"] ?? "Error age",
            "gender": data?["gender"] ?? "Error gender",
          });
          print(userDataList);
        });
      }
    });

    return userDataList;
  }

  // static Future<Map<String, String>>
}
