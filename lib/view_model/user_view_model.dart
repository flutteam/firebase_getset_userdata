import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/model/user.dart';
import 'package:firebase_getset_userdata/repository/user_repository.dart';
import 'package:flutter/material.dart';

class UserViewModel with ChangeNotifier {
  late final UserRepository _userRepository;

  late Stream<QuerySnapshot<User>> _userList;
  Stream<QuerySnapshot<User>> get userList => _userList;

  UserViewModel() {
    _userRepository = UserRepository();
    _userList = _userRepository.getUserData();
    notifyListeners();
  }
}
