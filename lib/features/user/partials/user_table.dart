import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/common/widgets/custom_choose_dialog.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/features/user/partials/user_modal.dart';
import 'package:syscost/features/user/user_controller.dart';

// ignore: must_be_immutable
class UsersTab extends StatefulWidget {
  final UserController controller;
  final VoidCallback onUserAction;
  List? userList;
  bool isLoading;

  UsersTab({
    super.key,
    required this.controller,
    required this.onUserAction,
    required this.userList,
    required this.isLoading,
  });

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
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
        await widget.controller.deleteUser(userId).then(
          (_) {
            widget.onUserAction();
          },
        );
      }
    }
  }

  Future<void> _alterUserStatus({
    required int userId,
    required String userName,
    required int currentStatus,
  }) async {
    final userChoose = await CustomChooseDialog(
      context: context,
      message:
          "Deseja realmente ${currentStatus == 0 ? "Ativar" : "Desativar"} o usuário $userName",
      progressButton: "Sim",
      cancelMessage: "Cancelar",
    );
    if (userChoose == 1) {
      if (userId != 1) {
        // user master can't be deactivated
        await widget.controller
            .alterUserStatus(
          userId: userId,
          currentStatus: currentStatus,
        )
            .then(
          (_) {
            widget.onUserAction();
          },
        );
      }
    }
  }

  void _showUserModal([UserModel? user]) {
    // User master can't be alter
    if (user?.id == 1) {
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) => PartialUserModal(
        userController: widget.controller,
        onUserAction: widget.onUserAction,
        user: user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? const Center(
            child: CustomCircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                if (widget.userList != null)
                  ...widget.userList!.map((user) {
                    return TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              user.id.toString(),
                              style: AppTextStyles.defaultText,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              user.login,
                              style: AppTextStyles.defaultText,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              user.status == 1 ? "Ativo" : "Inativo",
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
                                  onPressed: () {
                                    _showUserModal(user);
                                  },
                                  icon: const Icon(
                                    Icons.edit_document,
                                    color: AppColors.primaryDarkGray,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _alterUserStatus(
                                      userId: user.id,
                                      userName: user.login,
                                      currentStatus: user.status,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.power_settings_new,
                                    color: user.status == 1
                                        ? AppColors.primaryGreen
                                        : AppColors.primaryRed,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteUser(
                                      userId: user.id,
                                      userName: user.login,
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
