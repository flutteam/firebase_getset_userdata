import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserlistModel extends ChangeNotifier {
  Map<String, dynamic> _userData;
  UserlistModel(Map<String, dynamic> userData) : _userData = userData;

  Map<String, dynamic> get userData => _userData;

  Future<void> updateUserInformation({
    required String newName,
    required int newAge,
    required String newGender,
    required BuildContext context,
  }) async {
    // 사용자의 문서에 대한 참조 얻기
    DocumentReference<Map<String, dynamic>>? docRef = userData["docRef"];

    if (docRef != null) {
      // 사용자 문서의 현재 스냅샷 얻기
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await docRef.get();

      if (userSnapshot.exists) {
        print("사용자 정보 업데이트 중...");

        Map<String, dynamic> updatedData = {};

        // 새 값이 현재 값과 다른지 확인
        if (newName.isNotEmpty && newName != userData["name"]) {
          updatedData["name"] = newName;
        }
        if (newAge != 0 && newAge != userData["age"]) {
          updatedData["age"] = newAge;
        }
        if (newGender.isNotEmpty && newGender != userData["gender"]) {
          updatedData["gender"] = newGender;
        }

        // 변경된 값이 있는 경우에만 업데이트 수행
        if (updatedData.isNotEmpty) {
          await docRef.update(updatedData).then((_) {
            // 업데이트가 성공하면 화면을 닫고 업데이트된 데이터를 제공
            _userData = {
              ..._userData,
              ...updatedData,
            };
            notifyListeners();
            Navigator.pop(context, _userData);
            print("사용자 정보가 업데이트되었습니다");
          }).catchError((error) {
            // 업데이트 중 오류 처리
            print("사용자 정보 업데이트 중 오류 발생: $error");
          });
        } else {
          print("변경된 값이 없습니다.");
          // 변경된 값이 없으면 이전 화면으로 바로 이동
          Navigator.pop(context);
        }
      } else {
        print("문서를 찾을 수 없습니다. 사용자 정보 업데이트 불가능");
      }
    }
  }

  Future<bool> onBackPressed(BuildContext context) async {
    // 뒤로 가기 버튼을 눌렀을 때 다이얼로그 표시
    bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            "정말 뒤로 나가시겠습니까?\n수정한 내용은 저장되지 않습니다.",
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  // '나가기' 버튼 선택
                  Navigator.pop(context, true);
                },
                child: const Text("나가기"),
              ),
              TextButton(
                onPressed: () {
                  // '머무르기' 버튼 선택
                  Navigator.pop(context, false);
                },
                child: const Text("머무르기"),
              ),
            ],
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<String?> showGenderSelectionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Gender'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'man');
              },
              child: const Text('Man'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'woman'),
              child: const Text('Woman'),
            ),
          ],
        );
      },
    );
  }
}
