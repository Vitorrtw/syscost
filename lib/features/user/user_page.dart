import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/widgets/custom_choose_dialog.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/common/widgets/drawer_menu.dart';
import 'package:syscost/features/user/user_controller.dart';
import 'package:syscost/locator.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // Page Controller
  final _pageController = locator.get<UserController>();

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
          // Menu lateral
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
                            onPressed: () {},
                            child: Text(
                              "Cadastrar",
                              style: AppTextStyles.buttonText
                                  .copyWith(color: AppColors.primaryWhite),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed),
                            onPressed: () {
                              _pageController.getUsers();
                            },
                            child: Text(
                              "Ola",
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
          // Área principal com scroll
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: UsersTab(
                  controller: _pageController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UsersTab extends StatefulWidget {
  final UserController controller;
  const UsersTab({super.key, required this.controller});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  List? users;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    List? usersData = await widget.controller.getUsers();
    setState(() {
      users = usersData;
      isLoading = false;
    });
  }

  Future<void> _deleteUser({
    required int userId,
    required String userName,
  }) async {
    final userChoose = await CustomChooseDialog(
      context: context,
      message: "Deseja realmente excluir o usuário $userName?",
      progressButton: "Sim",
      cancelMessage: "Cancelar",
    );

    if (userChoose == 1) {
      if (userId != 1) {
        // user master can't be deleted
        widget.controller.deleteUser(userId);
      }
      setState(() {
        _getUsers();
      });
    }
  }

  Future<void> _deactivateUser({
    required int userId,
    required String userName,
  }) async {
    final userChoose = await CustomChooseDialog(
      context: context,
      message: "Deseja realmente desativar o usuário $userName",
      progressButton: "Sim",
      cancelMessage: "Cancelar",
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CustomCircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(20),
            child: Table(
              border: TableBorder.all(color: AppColors.primaryRed),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // ignore: prefer_const_constructors
                TableRow(
                  decoration: const BoxDecoration(color: AppColors.primaryRed),
                  children: const [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "ID",
                          style: AppTextStyles.titleTab,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Login",
                          style: AppTextStyles.titleTab,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Status",
                          style: AppTextStyles.titleTab,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Ações",
                          style: AppTextStyles.titleTab,
                        ),
                      ),
                    ),
                  ],
                ),
                if (users != null)
                  ...users!.map((user) {
                    return TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              user['ID'].toString(),
                              style: AppTextStyles.defaultText,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              user['LOGIN'],
                              style: AppTextStyles.defaultText,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              user['STATUS'] == 1 ? "Ativo" : "Inativo",
                              style: AppTextStyles.defaultText,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit_document,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deactivateUser(
                                      userId: user['ID'],
                                      userName: user["LOGIN"],
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.power_settings_new,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteUser(
                                      userId: user['ID'],
                                      userName: user["LOGIN"],
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  })
              ],
            ),
          );
  }
}
