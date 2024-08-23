class Validators {
  Validators._();

  static String? validateGenericNotNull(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo Obrigatorio";
    }
    return null;
  }
}
