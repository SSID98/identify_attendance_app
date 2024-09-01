import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key, required this.text1, required this.text2});

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15.0),
          child: Text(
            text1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            // width: size.width * 0.0,
            height: 40.0,
            width: 350.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(
                    0.0,
                    0.0,
                  ),
                  blurRadius: 0.1,
                  spreadRadius: 0,
                ), //BoxShadow
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text2,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
