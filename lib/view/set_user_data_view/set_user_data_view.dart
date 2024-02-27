import 'package:firebase_getset_userdata/view_model/new_code/set_user_data_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SetUserDataView extends StatelessWidget {
  late SetUserDataViewModel _setUserDataViewModel;

  SetUserDataView({super.key});

  final nameTextFieldController = TextEditingController();
  final ageTextFieldController = TextEditingController();
  final genderTextFieldController = TextEditingController();

  /// DB에 정보를 User 정보를 저장하는 함수
  void completionButtonPressed({required BuildContext context}) async {
    final name = nameTextFieldController.text;
    final age = int.parse(
        ageTextFieldController.text == "" ? "-1" : ageTextFieldController.text);
    final gender = genderTextFieldController.text;

    if (name == "" || age == -1 || gender == "") {
      createDialog(
        context: context,
        title: "내용 부족",
        description: "내용을 입력하세요",
      );
      return;
    }

    bool isSet = await _setUserDataViewModel.setUserData(
      name: name,
      age: age,
      gender: gender,
    );

    if (isSet) {
      createDialog(
        context: context,
        title: "유저 생성",
        description: "유저 정보가 생성되었습니다.",
      );
      clearTextField();
    } else {
      createDialog(
        context: context,
        title: "유저 생성 오류",
        description: "유저 정보가 생성되지 못했습니다.",
      );
    }
  }

  /// TextField를 모두 비우는 함수
  void clearTextField() {
    // Controller 초기화
    nameTextFieldController.clear();
    ageTextFieldController.clear();
    genderTextFieldController.clear();
  }

  /// 유저 정보가 생성되었을 때, Dialog를 띄우는 함수
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

  /// Gender를 선택할 때, SimpleDialog를 띄우는 함수
  void showGenderSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Gender'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                genderTextFieldController.text = "man";
                Navigator.pop(context);
              },
              child: const Text('Man'),
            ),
            SimpleDialogOption(
              onPressed: () {
                genderTextFieldController.text = "woman";
                Navigator.pop(context);
              },
              child: const Text('Woman'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _setUserDataViewModel = Provider.of<SetUserDataViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
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
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Name",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: nameTextFieldController,
                        decoration: const InputDecoration(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Age",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Gender",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: genderTextFieldController,
                        decoration: const InputDecoration(),
                        readOnly: true,
                        onTap: () async {
                          showGenderSelectionDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
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
                      "Create",
                      style: TextStyle(
                        fontSize: 13,
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
