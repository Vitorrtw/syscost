import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';

class CustomSidePainel extends StatelessWidget {
  final String buttonText;
  final Widget child;
  final String imagePath;

  const CustomSidePainel({
    super.key,
    required this.buttonText,
    required this.child,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryWhite,
          border: Border(
            right: BorderSide(
              color: AppColors.primaryRed,
              width: 5,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 5,
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
