import 'package:flutter/cupertino.dart';

//sorry this was meant to be the text field container settings
class TextfieldContainer extends StatelessWidget {
  final Widget child;
  final Color colour;

  const TextfieldContainer({
    super.key,
    required this.child,
    required this.colour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
