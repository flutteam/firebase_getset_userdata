import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final bool showBottomTabs;
  final Function(bool) onShowBottomTabsChanged;

  const UpdateScreen({
    Key? key,
    required this.userData,
    required this.showBottomTabs,
    required this.onShowBottomTabsChanged,
  }) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _genderController = TextEditingController();
  String newName = "";
  int newAge = 0;
  String newGender = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
        title: const Text(
          "User Details Update",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // 체크 아이콘을 눌렀을 때 사용자 정보 업데이트
                _updateUserInformation(
                  newName: newName,
                  newAge: newAge,
                  newGender: newGender,
                  context: context,
                );
              },
            ),
          ),
        ],
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          // 뒤로 가기 버튼 처리
          return await _onBackPressed(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: widget.userData["name"] ?? "",
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (value) {
                  // 텍스트가 변경될 때마다 이름 업데이트
                  setState(() {
                    newName = value;
                  });
                },
              ),
              TextFormField(
                initialValue: widget.userData["age"].toString(),
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // 텍스트가 변경될 때마다 나이 업데이트
                  setState(() {
                    newAge = int.tryParse(value) ?? 0;
                  });
                },
              ),
              GestureDetector(
                onTap: () async {
                  String? selectedGender =
                      await showGenderSelectionDialog(context);
                  if (selectedGender != null) {
                    setState(() {
                      newGender = selectedGender;
                    });
                  }
                },
                child: TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                  ),
                  readOnly: true,
                  onTap: () async {
                    String? selectedGender =
                        await showGenderSelectionDialog(context);
                    if (selectedGender != null) {
                      setState(() {
                        newGender = selectedGender;
                        _genderController.text = newGender;
                        print("newGender updated : $newGender");
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // UpdateScreen이 팝되어 UserDetailsScreen으로 돌아갈 때 bottom navigator를 다시 표시
    widget.onShowBottomTabsChanged(true);
    super.dispose();
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    // 뒤로 가기 버튼을 눌렀을 때 다이얼로그 표시
    return (await showDialog(
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
        )) ??
        false;
  }

  void _updateUserInformation({
    required String newName,
    required int newAge,
    required String newGender,
    required BuildContext context,
  }) async {
    // 사용자의 문서에 대한 참조 얻기
    DocumentReference<Map<String, dynamic>>? docRef = widget.userData["docRef"];

    if (docRef != null) {
      // 사용자 문서의 현재 스냅샷 얻기
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await docRef.get();

      if (userSnapshot.exists) {
        print("사용자 정보 업데이트 중...");

        Map<String, dynamic> updatedData = {};

        // 새 값이 현재 값과 다른지 확인
        if (newName.isNotEmpty && newName != widget.userData["name"]) {
          updatedData["name"] = newName;
        }
        if (newAge != 0 && newAge != widget.userData["age"]) {
          updatedData["age"] = newAge;
        }
        if (newGender.isNotEmpty && newGender != widget.userData["gender"]) {
          updatedData["gender"] = newGender;
        }

        // 변경된 값이 있는 경우에만 업데이트 수행
        if (updatedData.isNotEmpty) {
          await docRef.update(updatedData).then((_) {
            // 업데이트가 성공하면 화면을 닫고 업데이트된 데이터를 제공
            Navigator.pop(context, {
              "name": updatedData["name"] ?? widget.userData["name"],
              "age": updatedData["age"] ?? widget.userData["age"],
              "gender": updatedData["gender"] ?? widget.userData["gender"],
            });
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
              onPressed: () {
                Navigator.pop(context, 'woman');
              },
              child: const Text('Woman'),
            ),
          ],
        );
      },
    );
  }
}
