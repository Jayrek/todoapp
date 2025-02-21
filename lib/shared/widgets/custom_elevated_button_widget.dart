import 'package:flutter/material.dart';

class CustomElevatedButtonWidget extends StatelessWidget {
  const CustomElevatedButtonWidget({
    required this.backgroundColor,
    required this.onPressed,
    required this.childWidget,
    this.borderColor = Colors.black,
    super.key,
  });

  final Color backgroundColor;
  final Function()? onPressed;
  final Widget childWidget;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(220, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 2,
              color: borderColor,
            ),
          ),
          backgroundColor: backgroundColor),
      onPressed: onPressed,
      child: childWidget,
    );
  }
}
