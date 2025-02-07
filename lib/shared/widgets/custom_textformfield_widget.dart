import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  const CustomTextFormFieldWidget({
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.isObscure = false,
    super.key,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String hintText;
  final String labelText;
  final bool isObscure;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      validator: validator,
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        labelText: labelText,
        enabledBorder: outlineBorder(Colors.grey),
        focusedBorder: outlineBorder(Colors.blue),
        errorBorder: outlineBorder(Colors.red),
        focusedErrorBorder: outlineBorder(Colors.red),
      ),
    );
  }

  OutlineInputBorder outlineBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
