import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/model/user.dart';
import 'package:firebase_getset_userdata/view/get_user_data_view/get_user_data_detail_view.dart';
import 'package:firebase_getset_userdata/view/get_user_data_view/get_user_data_person_container_view.dart';
import 'package:firebase_getset_userdata/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetUserDataView extends StatelessWidget {
  const GetUserDataView({
    Key? key,
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
      body: Consumer<UserViewModel>(
        builder: (context, provider, child) {
          return StreamBuilder<QuerySnapshot<User>>(
            stream: provider.userList,
            builder: (context, AsyncSnapshot<QuerySnapshot<User>> snapshot) {
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
                            builder: (context) => GetUserDataDetailView(
                              userData: userData,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GetUserDataPersonContainerView(
                                // 각 사용자의 정보를 보여줌
                                name: userData["name"] ?? "Error name",
                                age: userData["age"] ?? "Error age",
                                gender: userData["gender"] ?? "Error gender",
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
