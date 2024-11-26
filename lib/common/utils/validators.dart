class Validators {
  Validators._();

  static String? validateGenericNotNull(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo Obrigatorio";
    }
    return null;
  }

  static String? validateUserLogin(String? value) {
    if (value!.length < 5 || value.isEmpty) {
      return "O Login do usuario deve conter no minimo 5 caracteres";
    }
  }

  static String? validateUserPassword(String? value) {
    if (value!.length < 8) {
      return "A senha do usuario deve conter no minimo 8 caracteres";
    }
  }
}
