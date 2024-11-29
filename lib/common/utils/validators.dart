class Validators {
  Validators._();

  static const int defaultTextNumCaracters = 60;

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
    return null;
  }

  static String? validateUserPassword(String? value) {
    if (value!.length < 8) {
      return "A senha do usuario deve conter no minimo 8 caracteres";
    }
    return null;
  }

  static String? validadePersonCep(String? value) {
    if (value!.length != 8 && value.isEmpty) {
      return "O CEP deve conter 8 Digitos";
    }
    return null;
  }

  static String? validatePersonUf(String? value) {
    if (value!.length != 2 && value.isEmpty) {
      return "A Sigla do Estado deve conter 2 digitos";
    }
    return null;
  }
}
