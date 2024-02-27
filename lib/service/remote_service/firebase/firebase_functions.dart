import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/model/user.dart';
import 'package:firebase_getset_userdata/service/remote_service/firebase/firebase_constants.dart';

class FirebaseFunctions {
  Stream<QuerySnapshot<User>> getUserData() {
    // https://firebase.flutter.dev/docs/firestore/usage#typing-collectionreference-and-documentreference
    // 위 링크의 [Typing CollectionReference and DocumentReference] 부분 참조
    // Converter를 통해서 User Model Class 형식으로 User Ref 정보 가져오기
    var usersRef = FirebaseConstants.colRefUser.withConverter<User>(
      fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );

    // snapshot 정보 반환하기
    return usersRef.snapshots();
  }

  Future<bool> setUserData(
      {required String name, required int age, required String gender}) async {
    try {
      await FirebaseConstants.colRefUser.doc().set({
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
