import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  final Widget icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const ActionItem({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
