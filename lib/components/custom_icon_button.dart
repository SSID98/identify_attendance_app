import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final double? minWidth;
  final BoxBorder? border;
  final Color? background;

  const CustomIconButton(
      {Key? key,
      required this.onTap,
      required this.icon,
      this.iconColor,
      this.iconSize,
      this.minWidth,
      this.border,
      this.background})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: background, shape: BoxShape.circle, border: border),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: iconColor ?? const Color(0xff9daab3),
        ),
        splashColor: Colors.transparent,
        splashRadius: (minWidth ?? 45) - 25,
        iconSize: iconSize ?? 22.0,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
            minWidth: minWidth ?? 45.0, minHeight: minWidth ?? 45.0),
      ),
    );
  }
}
