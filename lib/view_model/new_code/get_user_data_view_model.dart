import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/model/user.dart';
import 'package:firebase_getset_userdata/repository/user_repository.dart';
import 'package:flutter/material.dart';

class GetUserDataViewModel with ChangeNotifier {
  // MARK: - Properties
  late final UserRepository _userRepository;

  late User _userData;
  User get detailUserData => _userData;
  late DocumentReference _docRef;
  DocumentReference get detailDocRef => _docRef;

  // MARK: - States
  late Stream<QuerySnapshot<User>> _userList;
  Stream<QuerySnapshot<User>> get userList => _userList;

  // MARK: - Constructor
  GetUserDataViewModel() {
    _userRepository = UserRepository();
    _userList = _userRepository.getUserData();
    notifyListeners();
  }

  // MARK: - Methods
  void setDetailUserData(User userData, DocumentReference docRef) {
    _userData = userData;
    _docRef = docRef;
    notifyListeners();
  }

  void updateUserInformation({
    required User originalUser,
    required User modifiedUser,
    required DocumentReference? docRef,
    required BuildContext context,
  }) async {
    if (docRef != null) {
      // 사용자 문서의 현재 스냅샷 얻기
      DocumentSnapshot userSnapshot = await docRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> updatedData = {};

        String newName = modifiedUser.name ?? "";
        String originalName = originalUser.name ?? "";
        int newAge = modifiedUser.age ?? 0;
        int originalAge = originalUser.age ?? 0;
        String newGender = modifiedUser.gender ?? "";
        String originalGender = originalUser.gender ?? "";

        // 새 값이 현재 값과 다른지 확인
        if (newName.isNotEmpty && newName != originalName) {
          updatedData["name"] = newName;
        }
        if (newAge != 0 && newAge != originalAge) {
          updatedData["age"] = newAge;
        }
        if (newGender.isNotEmpty && newGender != originalGender) {
          updatedData["gender"] = newGender;
        }

        // 변경된 값이 있는 경우에만 업데이트 수행
        if (updatedData.isNotEmpty) {
          await docRef.update(updatedData).then((_) {
            // 업데이트가 성공하면 화면을 닫고 업데이트된 데이터를 제공
            Navigator.pop(context, {
              "name": newName,
              "age": newAge,
              "gender": newGender,
              "docRef": docRef,
            });
          }).catchError((error) {
            // 업데이트 중 오류 처리
            ErrorDescription(error);
          });
        } else {
          // 변경된 값이 없으면 이전 화면으로 바로 이동
          Navigator.pop(context);
        }
      } else {
        print("문서를 찾을 수 없습니다. 사용자 정보 업데이트 불가능");
      }
    }
  }

  Future<bool> deleteUserData({required BuildContext context}) async =>
      detailDocRef.delete().then(
        (value) {
          return true;
        },
      ).catchError(
        (err) {
          return false;
        },
      );
}
