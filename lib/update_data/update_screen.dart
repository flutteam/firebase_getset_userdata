import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatelessWidget {
  Map<String, dynamic> userData;

  String newName = "";

  int newAge = 0;

  String newGender = "";

  UpdateScreen({super.key, required this.userData});

  void _updateUserInformation(
      {required String newName,
      required int newAge,
      required String newGender,
      required BuildContext context}) async {
    // 'user' 컬렉션에서 해당 사용자의 문서 가져오기
    DocumentReference docRef = userData["docRef"];

    DocumentSnapshot userSnapshot = await docRef.get();
    // 문서가 존재하는지 확인
    if (userSnapshot.exists) {
      print("사용자 정보 업데이트 중...");

      // Firebase 'user' 컬렉션에서 해당 사용자의 문서를 업데이트
      await docRef.update({
        "name": newName,
        "age": newAge,
        "gender": newGender,
      }).then((_) {
        // 업데이트가 성공하면 이전 화면으로 이동
        Navigator.pop(context, {
          "name": newName,
          "age": newAge,
          "gender": newGender,
        });
        print("사용자 정보가 업데이트되었습니다");
      }).catchError((error) {
        // 업데이트 중 에러가 발생하면 처리할 로직을 구현할 수 있습니다.
        print("사용자 정보 업데이트 중 오류 발생: $error");
      });
    } else {
      print("문서를 찾을 수 없습니다. 사용자 정보 업데이트 불가능");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: userData["name"] ?? "",
              decoration: const InputDecoration(labelText: "name"),
              onChanged: (value) {
                newName = value;
              },
            ),
            TextFormField(
              initialValue: userData["age"].toString(),
              decoration: const InputDecoration(labelText: "age"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                newAge = int.parse(value);
              },
            ),
            TextFormField(
              initialValue: userData["gender"] ?? "",
              decoration: const InputDecoration(labelText: "gender"),
              onChanged: (value) {
                newGender = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 업데이트 실행;
                _updateUserInformation(
                    newName: newName,
                    newAge: newAge,
                    newGender: newGender,
                    context: context);
              },
              child: const Text("업데이트"),
            ),
          ],
        ),
      ),
    );
  }
}
