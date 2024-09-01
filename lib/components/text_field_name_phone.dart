import 'package:flutter/material.dart';
import 'package:identify_attendance_app/components/text_field._container.dart';

class TextFieldNamePhone extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String> onChanged;
  final Icon icon;
  final Color color;

  const TextFieldNamePhone({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextfieldContainer(
      colour: color,
      child: TextField(
          decoration: InputDecoration(
              icon: icon, border: InputBorder.none, hintText: hintText),
          onChanged: onChanged),
    );
  }
}
