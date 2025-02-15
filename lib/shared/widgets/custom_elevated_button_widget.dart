import 'package:flutter/material.dart';

class CustomElevatedButtonWidget extends StatelessWidget {
  const CustomElevatedButtonWidget(
      {required this.backgroundColor,
      required this.onPressed,
      required this.childWidget,
      this.textColor = Colors.white,
      super.key});

  final Color backgroundColor;
  final Function()? onPressed;
  final Color textColor;
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(220, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: backgroundColor),
      onPressed: onPressed,
      child: childWidget,
    );
  }
}
