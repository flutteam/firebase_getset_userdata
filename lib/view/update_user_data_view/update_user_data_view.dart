import 'package:firebase_getset_userdata/model/user.dart';
import 'package:firebase_getset_userdata/view_model/new_code/get_user_data_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UpdateUserDataView extends StatelessWidget {
  late GetUserDataViewModel _getUserDataViewModel;

  final nameTextFieldController = TextEditingController();
  final ageTextFieldController = TextEditingController();
  final genderTextFieldController = TextEditingController();

  UpdateUserDataView({super.key});

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

  @override
  Widget build(BuildContext context) {
    _getUserDataViewModel = Provider.of<GetUserDataViewModel>(context);
    nameTextFieldController.text = _getUserDataViewModel.detailUserData.name ?? "";
    ageTextFieldController.text = _getUserDataViewModel.detailUserData.age.toString();
    genderTextFieldController.text = _getUserDataViewModel.detailUserData.gender ?? "";
    
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
                _getUserDataViewModel.updateUserInformation(
                    modifiedUser: User(
                      name: nameTextFieldController.text,
                      age: int.parse(ageTextFieldController.text),
                      gender: genderTextFieldController.text,
                    ),
                    originalUser: User(
                      name: _getUserDataViewModel.detailUserData.name,
                      age: _getUserDataViewModel.detailUserData.age,
                      gender: _getUserDataViewModel.detailUserData.gender,
                    ),
                    docRef: _getUserDataViewModel.detailDocRef,
                    context: context);
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
                controller: nameTextFieldController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: ageTextFieldController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: genderTextFieldController,
                decoration: const InputDecoration(
                  labelText: "Gender",
                ),
                readOnly: true,
                onTap: () async {
                  String? selectedGender =
                      await showGenderSelectionDialog(context);
                  genderTextFieldController.text = selectedGender ?? "";
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
