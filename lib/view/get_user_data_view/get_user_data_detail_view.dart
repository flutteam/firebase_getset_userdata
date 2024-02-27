import 'package:firebase_getset_userdata/model/user.dart';
import 'package:firebase_getset_userdata/view/update_user_data_view/update_user_data_view.dart';
import 'package:firebase_getset_userdata/view_model/new_code/get_user_data_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GetUserDataDetailView extends StatelessWidget {
  late GetUserDataViewModel _getUserDataViewModel;

  GetUserDataDetailView({super.key});

  Future<void> modifyButtonOnTap(BuildContext context) async {
    Map<String, dynamic>? newUserData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return UpdateUserDataView();
        },
      ),
    );
    if (newUserData != null) {
      // TODO: 새로운 유저 데이터 state 변경 및 notify
      _getUserDataViewModel.setDetailUserData(
        User(
            name: newUserData["name"],
            age: newUserData["age"],
            gender: newUserData["gender"]),
        newUserData["docRef"],
      );
    }
  }

  void deleteButtonOnTap({required BuildContext context}) {
    createDeleteUserDialog(
      context: context,
      title: "유저 정보를 삭제하시겠습니까?",
      description: "삭제된 정보는 복원할 수 없습니다.",
    );
  }

  void createDeleteUserDialog({
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
              const SizedBox(
                height: 20,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Content Description
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                description,
              ),
            ],
          ),
          // ConfirmButton
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    "취소",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[300],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    "확인",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[300],
                    ),
                  ),
                  onPressed: () async {
                    bool deleted = await _getUserDataViewModel.deleteUserData(
                        context: context);
                    if (deleted) {
                      Navigator.popUntil(context, ModalRoute.withName("/"));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _getUserDataViewModel = Provider.of<GetUserDataViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
        title: const Text(
          "User Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Text("Name: ${_getUserDataViewModel.detailUserData.name}",
              style: const TextStyle(
                fontSize: 18,
              )),
          Text("Age: ${_getUserDataViewModel.detailUserData.age}",
              style: const TextStyle(
                fontSize: 18,
              )),
          Text("Gender: ${_getUserDataViewModel.detailUserData.gender}",
              style: const TextStyle(
                fontSize: 18,
              )),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => modifyButtonOnTap(context),
                icon: const Icon(
                  Icons.mode_edit,
                  size: 25,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () => deleteButtonOnTap(context: context),
                icon: const Icon(
                  Icons.delete_forever,
                  size: 25,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: null,
    );
  }
}
