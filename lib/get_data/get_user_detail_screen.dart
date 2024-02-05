import 'package:firebase_getset_userdata/update_data/update_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserDetailsScreen extends StatefulWidget {
  Map<String, dynamic> userData;
  final bool showBottomTabs;
  final Function(bool) onShowBottomTabsChanged;

  UserDetailsScreen({
    Key? key,
    required this.userData,
    required this.showBottomTabs,
    required this.onShowBottomTabsChanged,
  }) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Future<void> modifyButtonOnTap(BuildContext context) async {
    Map<String, dynamic>? newUserData = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        widget.onShowBottomTabsChanged(false);
        return UpdateScreen(
          userData: widget.userData,
          showBottomTabs: widget.showBottomTabs,
          onShowBottomTabsChanged: widget.onShowBottomTabsChanged,
        );
      }),
    );
    if (newUserData != null) {
      setState(() {
        widget.userData = newUserData;
      });
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
                  onPressed: () {
                    print("확인버튼이 눌렸습니다....");
                    deleteUserData(
                      context: context,
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// 유저 정보를 DB에서 삭제하는 함수
  void deleteUserData({
    required BuildContext context,
  }) {
    widget.userData["docRef"].delete().then((value) {
      print("유저 정보 삭제 완료 !");
      Navigator.popUntil(context, ModalRoute.withName("/"));
    }).catchError((err) {
      print("유저 정보 삭제 실패....");
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          Text("Name: ${widget.userData["name"] ?? "Error name"}",
              style: const TextStyle(
                fontSize: 18,
              )),
          Text("Age: ${widget.userData["age"] ?? "Error age"}",
              style: const TextStyle(
                fontSize: 18,
              )),
          Text("Gender: ${widget.userData["gender"] ?? "Error gender"}",
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
