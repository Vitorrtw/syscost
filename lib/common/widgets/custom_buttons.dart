// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_text_styles.dart';

class CustomButtons extends StatelessWidget {
  final String buttonText;
  final double width;
  final VoidCallback onPressed;
  final Color textColor;
  final Color backgroundColor;
  final IconData? icon;

  const CustomButtons({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.textColor,
    required this.backgroundColor,
    required this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: Text(
          buttonText,
          style: AppTextStyles.buttonText.copyWith(color: textColor),
        ),
        icon: icon != null ? Icon(icon) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
