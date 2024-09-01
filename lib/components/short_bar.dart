import 'package:flutter/material.dart';

class ShortBar extends StatelessWidget {
  const ShortBar({Key? key, this.height, this.width, this.color})
      : super(key: key);

  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 4,
      width: width ?? 25,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }
}
