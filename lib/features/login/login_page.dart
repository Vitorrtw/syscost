// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/constants/routes.dart';
import 'package:syscost/common/utils/validators.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/common/widgets/custom_error_dialog.dart';
import 'package:syscost/features/login/login_controller.dart';
import 'package:syscost/features/login/login_state.dart';
import 'package:syscost/locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variables
  bool _showPassword = true;

  // Forms Key
  final _loginFormKey = GlobalKey<FormState>();

  // Controllers Field
  final _userNameController = TextEditingController();
  final _userPasswordController = TextEditingController();

  // Controllers
  final _pageController = locator.get<LoginController>();

  // Methods

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handleLoginStateChange);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handleLoginStateChange);
    _userNameController.dispose();
    _userPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      await _pageController.doLogin(
        userName: _userNameController.text,
        userPassword: _userPasswordController.text,
      );
    }
  }

  void _handleLoginStateChange() {
    switch (_pageController.state.runtimeType) {
      case LoginStateLoading:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
        break;
      case LoginStateFailure:
        Navigator.pop(context);
        showCustomErrorDialog(
          context,
          (_pageController.state as LoginStateFailure).error,
        );
        break;
      case LoginStateSuccess:
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, NamedRoute.homePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/app/img/syscost_logo.png",
                  fit: BoxFit.cover,
                  height: 250,
                ),
                Expanded(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: Validators.validateGenericNotNull,
                          controller: _userNameController,
                          decoration: const InputDecoration(
                            labelText: "Usuário",
                            hintText: "Digite o seu Usuário",
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: Validators.validateGenericNotNull,
                          controller: _userPasswordController,
                          obscureText: _showPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                )),
                            prefixIcon: const Icon(
                              Icons.key,
                            ),
                            labelText: "Senha",
                            hintText: "Digite sua senha",
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onLogin,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed),
                            child: Text(
                              "Entrar",
                              style: AppTextStyles.buttonText
                                  .copyWith(color: AppColors.primaryWhite),
                            ),
                          ),
                        )
                      ],
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
