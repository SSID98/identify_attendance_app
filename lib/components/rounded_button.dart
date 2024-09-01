import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {super.key, this.colour, this.label, required this.onPress});

  final String? label;
  final Color? colour;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        // Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 100.0, right: 100.0),
            child: Text(
              label!,
              style: const TextStyle(color: Colors.white),
              // 'Log In',
            ),
          ),
        ),
      ),
    );
  }
}
