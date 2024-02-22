import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConstants {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static CollectionReference colRefUser = db.collection("user");
}
