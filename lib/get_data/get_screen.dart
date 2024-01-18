import 'package:firebase_getset_userdata/get_data/get_model.dart';
import 'package:flutter/material.dart';

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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: GetModel.streamData(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중일 때
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 에러가 발생했을 때
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // 데이터가 없을 때
            return const Center(child: Text('No data available'));
          } else {
            // 데이터가 정상적으로 로드되었을 때
            List<Map<String, dynamic>> userDataList = snapshot.data!;

            return ListView.builder(
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
                      name: userData["name"] ?? "Error name",
                      age: userData["age"] ?? 0,
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

// 나머지 코드는 동일하게 유지

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

  const UserDetailsScreen({required this.userData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
          ],
        ),
      ),
    );
  }
}
