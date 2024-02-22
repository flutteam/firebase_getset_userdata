import 'package:flutter/material.dart';

class GetUserDataPersonContainerView extends StatelessWidget {
  final String name;
  final dynamic age;
  final String gender;

  const GetUserDataPersonContainerView({
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
