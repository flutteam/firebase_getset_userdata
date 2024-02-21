import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  int age;
  String gender;
  DocumentReference<Map<String, dynamic>> docRef;

  UserModel(
      {required this.name,
      required this.age,
      required this.gender,
      required this.docRef});
}
