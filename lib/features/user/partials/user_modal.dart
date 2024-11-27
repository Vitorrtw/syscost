import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/common/utils/validators.dart';
import 'package:syscost/features/user/user_controller.dart';

class PartialUserModal extends StatefulWidget {
  final VoidCallback onUserAction;

  final UserModel? user;
  final UserController userController;

  const PartialUserModal({
    super.key,
    required this.onUserAction,
    required this.userController,
    this.user,
  });

  @override
  State<PartialUserModal> createState() => _PartialUserModalState();
}

class _PartialUserModalState extends State<PartialUserModal> {
  // Form Key
  final _formUserKey = GlobalKey<FormState>();

  /// Form fields controllers
  final _userLoginController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  @override
  void dispose() {
    _userLoginController.dispose();
    _userPasswordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _setUserData() {
    if (widget.user != null) {
      _userLoginController.text = widget.user!.login!;
      _userNameController.text = widget.user!.name!;
    }
  }

  Future<void> _alterUser() async {
    if (_formUserKey.currentState!.validate()) {
      final UserModel user = UserModel(
        id: widget.user?.id,
        login: _userLoginController.text,
        name: _userNameController.text,
        password: _userPasswordController.text,
        status: widget.user?.status,
      );

      await widget.userController.alterUserData(user: user).then(
        (_) {
          widget.onUserAction();
        },
      );
    }
  }

  Future<void> _createUser() async {
    if (_formUserKey.currentState!.validate()) {
      final UserModel user = UserModel(
        id: null,
        login: _userLoginController.text,
        name: _userNameController.text,
        password: _userPasswordController.text,
        status: null,
      );
      await widget.userController.createUser(user: user).then((_) {
        widget.onUserAction();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(39),
          child: Form(
            key: _formUserKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.user == null
                      ? "Cadastrar Usuario."
                      : "Alterar Usuario.",
                  style: AppTextStyles.titleText,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _userLoginController,
                  validator: Validators.validateUserLogin,
                  decoration: const InputDecoration(
                    labelText: "Login do usuario",
                    hintText: "Digite o login do usuario",
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _userNameController,
                  validator: Validators.validateGenericNotNull,
                  decoration: const InputDecoration(
                    labelText: "Nome do Usuario.",
                    hintText: "Digite o nome do usuario",
                    prefixIcon: Icon(
                      Icons.textsms_outlined,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _userPasswordController,
                  obscureText: true,
                  validator: Validators.validateUserPassword,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.key),
                    labelText: "Senha",
                    hintText: "Digite a senha do usuario",
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.user == null) {
                        _createUser();
                      } else {
                        _alterUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                    ),
                    child: Text(
                      widget.user == null ? "Cadastrat" : "Alterar",
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
