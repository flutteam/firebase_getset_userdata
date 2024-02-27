import 'package:firebase_getset_userdata/repository/user_repository.dart';
import 'package:flutter/material.dart';

class SetUserDataViewModel with ChangeNotifier {
  late final UserRepository _userRepository;

  SetUserDataViewModel() {
    _userRepository = UserRepository();
  }

  // MARK: - Methods
  Future<bool> setUserData({
    required String name,
    required int age,
    required String gender,
  }) async {
    return await _userRepository.setUserData(
      name: name,
      age: age,
      gender: gender,
    );
  }
}
