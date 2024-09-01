import 'package:flutter/material.dart';

class SideBarListWidget extends StatelessWidget {
  const SideBarListWidget(
      {super.key,
      required this.icon,
      required this.text1,
      required this.text2,
      required this.onPress});

  final IconData icon;
  final String text1;
  final String text2;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: Icon(icon),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text1,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      text2,
                      style: TextStyle(
                          fontSize: 15, color: Colors.black.withOpacity(0.80)),
                    ),
                  ],
                ),
              ],
            ),
            onTap: onPress),
      ),
    );
  }
}
