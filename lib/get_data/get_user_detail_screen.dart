import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getset_userdata/update_data/update_screen.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  Map<String, dynamic> userData;

  UserDetailsScreen({required this.userData, Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Future<void> modifyButtonOnTap(BuildContext context) async {
    Map<String, dynamic>? newUserData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateScreen(userData: widget.userData),
      ),
    );
    if (newUserData != null) {
      setState(() {
        widget.userData = newUserData;
      });
    }
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
              // IconButton(
              //   // onPressed: () => updateButtonOnTap(context),
              //   icon: const Icon(
              //     Icons.delete_forever,
              //     size: 25,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
