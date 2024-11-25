import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/widgets/drawer_menu.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await windowManager.setResizable(true);
      await windowManager.center();
      await windowManager.setMaximizable(true);
      await windowManager.setTitle("Menu");
      await windowManager.maximize();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: Row(
          children: [
            Text(
              "SisCont",
              style: AppTextStyles.titleText.copyWith(
                color: AppColors.primaryWhite,
              ),
            )
          ],
        ),
      ),
      drawer: const DrawerMenu(),
    );
  }
}
