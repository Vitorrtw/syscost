// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/common/widgets/custom_error_dialog.dart';
import 'package:syscost/common/widgets/custom_success_dialog.dart';
import 'package:syscost/common/widgets/drawer_menu.dart';
import 'package:syscost/features/user/partials/user_modal.dart';
import 'package:syscost/features/user/partials/user_table.dart';
import 'package:syscost/features/user/user_controller.dart';
import 'package:syscost/features/user/user_state.dart';
import 'package:syscost/locator.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List? userList;
  bool isLoading = true;

  // Page Controller
  final _pageController = locator.get<UserController>();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handleUserStateChange);
    _getUsers();
  }

  void _handleUserStateChange() {
    switch (_pageController.state.runtimeType) {
      case UserStateSuccess:
        Navigator.pop(context);
        showCustomSuccessDialog(
            context, (_pageController.state as UserStateSuccess).message!);
        break;
      case UserStateLoading:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
        break;
      case UserStateError:
        showCustomErrorDialog(
            context, (_pageController.state as UserStateError).error);
        break;
    }
  }

  Future<void> _getUsers() async {
    final userData = await _pageController.getUsers();
    setState(() {
      userList = userData;
      isLoading = false;
    });
  }

  void _showUserModal([UserModel? user]) {
    showModalBottomSheet(
      context: context,
      builder: (context) => PartialUserModal(
        userController: _pageController,
        onUserAction: _getUsers,
        user: user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: Text(
          "SisCont",
          style:
              AppTextStyles.titleText.copyWith(color: AppColors.primaryWhite),
        ),
      ),
      drawer: const DrawerMenu(),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: const BoxDecoration(
              color: AppColors.primaryWhite,
              border: Border(
                right: BorderSide(color: AppColors.primaryRed, width: 5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/app/img/user_page.gif",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 0.23,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed),
                            onPressed: _showUserModal,
                            child: Text(
                              "Cadastrar",
                              style: AppTextStyles.buttonText
                                  .copyWith(color: AppColors.primaryWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Usuarios Cadastrados",
                        style: AppTextStyles.titleText,
                      ),
                    ),
                    UsersTab(
                      controller: _pageController,
                      isLoading: isLoading,
                      userList: userList,
                      onUserAction: _getUsers,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
