// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_text_styles.dart';

class CustomTableHeadCell extends StatelessWidget {
  final String text;

  const CustomTableHeadCell({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: AppTextStyles.titleTab,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
