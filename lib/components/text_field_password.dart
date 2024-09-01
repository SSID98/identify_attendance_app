import 'package:flutter/material.dart';
import 'package:identify_attendance_app/components/text_field._container.dart';

class PasswordTextField extends StatefulWidget {
  final Widget icon;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Color coloour;

  const PasswordTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.onChanged,
    required this.coloour,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordVisible = false; // Start with password hidden

  @override
  Widget build(BuildContext context) {
    return TextfieldContainer(
      colour: widget.coloour,
      child: TextField(
        obscureText: !_passwordVisible, // Show password if not obscured
        decoration: InputDecoration(
          icon: widget.icon,
          border: InputBorder.none,
          hintText: widget.hintText,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _passwordVisible = !_passwordVisible; // Toggle visibility
              });
            },
            child: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
