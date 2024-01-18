import 'package:firebase_getset_userdata/firebase/firebase_constant.dart';

class GetModel {
  // Firebase Firestore에서 user 컬렉션의 데이터를 스트리밍하는 메소드
  static Stream<List<Map<String, dynamic>>> streamData() {
    return FirebaseManager.db
        .collection("user")
        .snapshots()
        .map((querySnapshot) {
      List<Map<String, dynamic>> userDataList = [];

      for (var docSnapshot in querySnapshot.docs) {
        // 각 user의 데이터를 가져옴
        final data = docSnapshot.data();

        // 각 user의 데이터를 Map으로 구성하여 리스트에 추가
        Map<String, dynamic> userDataMap = {
          "name": data["name"] ?? "Error name",
          "age": data["age"] ?? "Error age",
          "gender": data["gender"] ?? "Error gender",
        };
        userDataList.add(userDataMap);
      }

      print(userDataList);

      // 스트림에 데이터를 전달
      return userDataList;
    });
  }
}
