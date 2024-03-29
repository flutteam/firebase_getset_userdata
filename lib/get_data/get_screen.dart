import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/get_data/get_model.dart';
import 'package:firebase_getset_userdata/get_data/get_user_detail_screen.dart';
import 'package:flutter/material.dart';

class GetScreen extends StatelessWidget {
  final bool showBottomTabs;
  final Function(bool) onShowBottomTabsChanged;

  const GetScreen({
    Key? key,
    required this.showBottomTabs,
    required this.onShowBottomTabsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
        title: const Text(
          "User List",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
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
                          "docRef": doc.reference,
                        })
                    .toList();

            return ListView.builder(
              // ListView.builder : 리스트 형태로 화면에 표시
              itemCount: userDataList.length,
              itemBuilder: (context, index) {
                var userData = userDataList[index];
                return GestureDetector(
                  onTap: () {
                    // 유저 정보를 표시하는 화면으로
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(
                          userData: userData,
                          showBottomTabs: showBottomTabs,
                          onShowBottomTabsChanged: onShowBottomTabsChanged,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          PersonContainer(
                            // 각 사용자의 정보를 보여줌
                            name: userData["name"] ?? "Error name",
                            age: userData["age"] ?? "Error age",
                            gender: userData["gender"] ?? "Error gender",
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
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
    Size deviceSize = MediaQuery.of(context).size;

    return Container(
      height: deviceSize.height / 10,
      width: deviceSize.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.purple[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
