import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/features/person/person_controller.dart';

class PersonModal extends StatefulWidget {
  final VoidCallback onPersonAction;
  final PersonModel? person;
  final PersonController personController;
  const PersonModal({
    super.key,
    required this.onPersonAction,
    this.person,
    required this.personController,
  });

  @override
  State<PersonModal> createState() => _PersonModalState();
}

class _PersonModalState extends State<PersonModal> {
  // Form Key
  final _formPersonKey = GlobalKey<FormState>();

  // form fields controllers
  final _personTellController = TextEditingController();
  final _personAddressController = TextEditingController();
  final _personNumberController = TextEditingController();
  final _personDistrictController = TextEditingController();
  final _personCityController = TextEditingController();
  final _personCepController = TextEditingController();
  final _personUfController = TextEditingController();
  final _personNameController = TextEditingController();

  void _setPersonData() async {
    if (widget.person != null) {
      _personAddressController.text = widget.person!.address!;
      _personNumberController.text = widget.person!.number!;
      _personCepController.text = widget.person!.cep!;
      _personCityController.text = widget.person!.city!;
      _personNameController.text = widget.person!.name!;
      _personUfController.text = widget.person!.uf!;
      _personDistrictController.text = widget.person!.district!;
      _personTellController.text = widget.person!.tell!;
    }
  }

  PersonModel _getPersonDataFromForm() {
    return PersonModel(
      id: widget.person?.id,
      name: _personNameController.text.trim(),
      status: widget.person == null ? 1 : widget.person?.status,
      tell: _personTellController.text.trim(),
      address: _personAddressController.text.trim(),
      number: _personNameController.text.trim(),
      district: _personDistrictController.text.trim(),
      city: _personCityController.text.trim(),
      cep: _personCepController.text.trim(),
      uf: _personUfController.text.trim(),
    );
  }

  Future<void> _createPerson() async {
    if (_formPersonKey.currentState!.validate()) {
      final PersonModel person = _getPersonDataFromForm();

      await widget.personController.createPerson(person: person).then(
        (_) {
          widget.onPersonAction();
        },
      );
    }
  }

  Future<void> _alterPerson() async {
    if (_formPersonKey.currentState!.validate()) {
      final PersonModel person = _getPersonDataFromForm();
    }
  }

  @override
  void dispose() {
    _personNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _setPersonData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 800,
          ),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formPersonKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Image.asset(
                          "assets/app/img/person_create.gif",
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.person == null
                                  ? "Cadastrar Pessoa"
                                  : "Alterar Pessoa",
                              style: AppTextStyles.titleText,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _personNameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppColors.primaryRed,
                                ),
                                labelText: "Nome:",
                                hintText: "Digite o nome.",
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _personTellController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: "Telefone",
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                              inputFormatters: [
                                PhoneInputFormatter(defaultCountryCode: "BR")
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _personAddressController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.streetview,
                                  color: AppColors.primaryRed,
                                ),
                                labelText: "Endereço:",
                                hintText: "Digite o nome.",
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _personNumberController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.numbers,
                                  color: AppColors.primaryRed,
                                ),
                                labelText: "Numero:",
                                hintText: "Digite o numero do endereço.",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _personCepController,
                    maxLength: 8,
                    decoration: const InputDecoration(
                      counterText: "",
                      prefixIcon: Icon(
                        Icons.card_giftcard_sharp,
                        color: AppColors.primaryRed,
                      ),
                      labelText: "CEP:",
                      hintText: "Digite o CEP.",
                    ),
                  ),
                  TextFormField(
                    controller: _personDistrictController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_pin,
                        color: AppColors.primaryRed,
                      ),
                      labelText: "Bairro:",
                      hintText: "Digite o nome do bairro.",
                    ),
                  ),
                  TextFormField(
                    controller: _personCityController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: AppColors.primaryRed,
                      ),
                      labelText: "Cidade:",
                      hintText: "Digite o numero do endereço.",
                    ),
                  ),
                  TextFormField(
                    controller: _personUfController,
                    maxLength: 2,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.map,
                        color: AppColors.primaryRed,
                      ),
                      labelText: "Estado:",
                      hintText: "Digite a Sigla do Estado.",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed),
                      onPressed: () {
                        if (widget.person == null) {
                          _createPerson();
                        } else {}
                      },
                      child: Text(
                        widget.person == null ? "Cadastrar" : "Alterar",
                        style: AppTextStyles.buttonText
                            .copyWith(color: AppColors.primaryWhite),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
