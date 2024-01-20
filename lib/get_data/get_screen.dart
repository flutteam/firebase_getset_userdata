import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/get_data/get_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetScreen extends StatelessWidget {
  const GetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: const Text(
          "Firebase CRUD Practice",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        // StreamBuilder : Firebase Cloud Firestore의 실시간 스트림 처리
        stream: GetModel.getUserData(), // 'user' 컬렉션의 데이터를 스트리밍
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중일 때
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 에러가 발생했을 때
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // 데이터가 없을 때
            return const Center(child: Text('No data available'));
          } else {
            // 데이터가 정상적으로 로드되었을 때
            List<Map<String, dynamic>> userDataList =
                snapshot.data!.docs // take() : 특정 횟수만큼 불러오는 메소드
                    .map((doc) => {
                          "name": doc["name"] ?? "Error name",
                          "age": doc["age"] ?? "Error age",
                          "gender": doc["gender"] ?? "Error gender",
                          // userDataList에 유저 정보를 담고 있는 firebase doc 주소를 저장
                          "docRefUser": doc.reference,
                        })
                    .toList();

            return ListView.builder(
              // ListView.builder : 리스트 형태로 화면에 표시
              itemCount: userDataList.length,
              itemBuilder: (context, index) {
                var userData = userDataList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // 유저 정보를 표시하는 화면으로
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserDetailsScreen(userData: userData),
                        ),
                      );
                    },
                    child: PersonContainer(
                      // 각 사용자의 정보를 보여줌
                      name: userData["name"] ?? "Error name",
                      age: userData["age"] ?? "Error age",
                      gender: userData["gender"] ?? "Error gender",
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PersonContainer extends StatelessWidget {
  final String name;
  final dynamic age;
  final String gender;

  const PersonContainer({
    required this.name,
    required this.age,
    required this.gender,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 500,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.purple[50],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(
                fontSize: 20,
              )),
        ],
      ),
    );
  }
}

class UserDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserDetailsScreen({
    required this.userData,
    Key? key,
  }) : super(key: key);

  void modifyButtonOnTap() {}

  void deleteButtonTapped({required BuildContext context}) {
    // TODO: 정말로 삭제할 것이냐는 알림 팝업 출력
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
    userData["docRefUser"].delete().then((value) {
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
        title: const Text("User Details"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Text("Name: ${userData["name"] ?? "Error name"}",
              style: const TextStyle(
                fontSize: 18,
              )),
          Text("Age: ${userData["age"] ?? "Error age"}",
              style: const TextStyle(
                fontSize: 18,
              )),
          Text("Gender: ${userData["gender"] ?? "Error gender"}",
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
                onPressed: modifyButtonOnTap,
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
                onPressed: () {
                  return deleteButtonTapped(context: context);
                },
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
    );
  }
}
