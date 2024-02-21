import 'package:firebase_getset_userdata/ViewModel/user_list_model.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  final Map<String, dynamic> userData;
  final bool showBottomTabs;
  final Function(bool) onShowBottomTabsChanged;

  const UserList({
    Key? key,
    required this.userData,
    required this.showBottomTabs,
    required this.onShowBottomTabsChanged,
  }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final TextEditingController _genderController = TextEditingController();
  String newName = "";
  int newAge = 0;
  String newGender = "";

  @override
  Widget build(BuildContext context) {
    UserlistModel userModel = UserlistModel(widget.userData);

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
                userModel.updateUserInformation(
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
          return await userModel.onBackPressed(context);
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
                      await userModel.showGenderSelectionDialog(context);
                  setState(() {
                    newGender = selectedGender ?? '';
                  });
                },
                child: TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                  ),
                  readOnly: true,
                  onTap: () async {
                    String? selectedGender =
                        await userModel.showGenderSelectionDialog(context);
                    setState(() {
                      newGender = selectedGender ?? '';
                      _genderController.text = newGender;
                      print("newGender updated : $newGender");
                    });
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
}
