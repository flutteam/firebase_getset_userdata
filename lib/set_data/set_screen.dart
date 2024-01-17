// ignore_for_file: avoid_print, must_be_immutable
import 'package:firebase_getset_userdata/set_data/set_model.dart';
import 'package:flutter/material.dart';

class SetScreen extends StatelessWidget {
  SetScreen({super.key});

  final nameTextFieldController = TextEditingController();
  final ageTextFieldController = TextEditingController();
  final genderTextFieldController = TextEditingController();
  String name = "";
  int age = -1;
  String gender = "";

  /// DB에 정보를 User 정보를 저장하는 함수
  void completionButtonPressed({required BuildContext context}) {
    if (name == "" || age == -1 || gender == "") {
      createDialog(
        context: context,
        title: "내용 부족",
        description: "내용을 입력하세요",
      );
      return;
    }
    User.setUserData(name: name, age: age, gender: gender);
    createDialog(
      context: context,
      title: "유저 생성",
      description: "유저 정보가 생성되었습니다.",
    );
    clearTextField();
  }

  void clearTextField() {
    nameTextFieldController.clear();
    ageTextFieldController.clear();
    genderTextFieldController.clear();
  }

  void createDialog({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: [
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                description,
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                child: const Text(
                  "확인",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[500],
        title: const Text(
          "User Create",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadiusDirectional.circular(15),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "이름",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Container(
                      width: 250,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: nameTextFieldController,
                        onChanged: ((text) {
                          name = text;
                        }),
                        decoration: const InputDecoration(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadiusDirectional.circular(15),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "나이",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Container(
                      width: 250,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: ageTextFieldController,
                        onChanged: ((text) {
                          int? inputValue = int.tryParse(text);
                          if (inputValue != null) {
                            // 정수로 변환된 값 사용
                            age = inputValue;
                          } else {
                            print('올바른 숫자를 입력하세요.');
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadiusDirectional.circular(15),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "성별",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Container(
                      width: 250,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: genderTextFieldController,
                        onChanged: ((text) {
                          gender = text;
                        }),
                        decoration: const InputDecoration(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadiusDirectional.circular(10),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      completionButtonPressed(context: context);
                    },
                    child: const Text(
                      "완료",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
