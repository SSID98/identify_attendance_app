import 'package:flutter/material.dart';
import 'package:identify_attendance_app/components/text_field._container.dart';

//this is for the email textfield
class TextFieldEmail extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final ValueChanged<String> Onchanged;
  final Color coloour;

  const TextFieldEmail({
    super.key,
    required this.hintText,
    required this.icon,
    required this.Onchanged,
    required this.coloour,
  });

  @override
  Widget build(BuildContext context) {
    return TextfieldContainer(
      colour: coloour,
      child: TextField(
          decoration: InputDecoration(
              icon: icon, border: InputBorder.none, hintText: hintText),
          onChanged: Onchanged),
    );
  }
}
