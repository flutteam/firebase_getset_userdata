import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/service/remote_service/firebase/firebase_functions.dart';
import '../model/user.dart';

class UserRepository {
  final FirebaseFunctions _remoteService = FirebaseFunctions();

  Stream<QuerySnapshot<User>> getUserData() {
    return _remoteService.getUserData();
  }
}
