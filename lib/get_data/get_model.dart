import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/firebase/firebase_constant.dart';

// 해당 컬렉션의 데이터가 변경될 때마다 실시간으로 업데이트된 데이터를 얻을 수 있음.
class GetModel {
  // Firebase Firestore에서 user 컬렉션의 데이터를 스트리밍하는 메소드
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    return FirebaseManager.db.collection("user").snapshots();
  }
}
