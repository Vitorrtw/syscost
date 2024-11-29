import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/constants/routes.dart';
import 'package:window_manager/window_manager.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await windowManager.setResizable(true);
      await windowManager.center();
      await windowManager.setMinimumSize(const Size(800, 400));
      await windowManager.setMaximizable(true);
      await windowManager.setTitle("Usuarios");
      await windowManager.maximize();
    });
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/app/img/siscont_icon.png",
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Menu",
                  style: AppTextStyles.titleText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_add_alt_1),
            title: const Text("Usuario"),
            onTap: () {
              Navigator.pushReplacementNamed(context, NamedRoute.userPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Pessoas"),
            onTap: () {
              Navigator.pushReplacementNamed(context, NamedRoute.personPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.more),
            title: const Text("Corte"),
            onTap: () {
              Navigator.pushReplacementNamed(context, NamedRoute.cutPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.yard_rounded),
            title: const Text("Bordado"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.villa_rounded),
            title: const Text("Facção"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: const Text("Acabamento"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text("Titulos"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
