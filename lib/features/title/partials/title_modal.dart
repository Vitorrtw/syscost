import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/models/title_model.dart';
import 'package:syscost/common/utils/datetime_adapter.dart';
import 'package:syscost/common/utils/validators.dart';
import 'package:syscost/common/widgets/custom_buttons.dart';
import 'package:syscost/common/widgets/custom_date_selector.dart';
import 'package:syscost/common/widgets/custom_error_dialog.dart';
import 'package:syscost/common/widgets/custom_search_person.dart';
import 'package:syscost/features/title/title_controller.dart';

class TitleModal extends StatefulWidget {
  final TitleModel? title;
  final TitleController? controller;
  final VoidCallback onRefresh;

  const TitleModal({
    super.key,
    this.title,
    this.controller,
    required this.onRefresh,
  });

  @override
  State<TitleModal> createState() => _TitleModalState();
}

class _TitleModalState extends State<TitleModal> {
  // Form Key
  final formKey = GlobalKey<FormState>();

  // Variables
  PersonModel? _personSelected;
  final List<String> _titleTypes = ["Pagar", "Receber"];
  String? _selectedTitleType;

  /// Field Controllers
  final titleNameController = TextEditingController();
  final titlePersonController = TextEditingController();
  final titleValueController = TextEditingController();
  final titleStatusController = TextEditingController();
  final titleDueDateController = TextEditingController();
  final titleDiscountController = TextEditingController();
  final titleFeesController = TextEditingController();
  final titleDescriptionController = TextEditingController();

  /// Methods
  double _checkValue(String value) {
    if (value.isEmpty) {
      return 0;
    }
    return double.parse(value.replaceAll(",", "."));
  }

  bool _checkTitleValue() {
    final titleValue = _checkValue(titleValueController.text);
    final titleDiscount = _checkValue(titleDiscountController.text);
    if (titleDiscount > titleValue) return false;
    return true;
  }

  TitleModel _createTitle() {
    final titleValue = _checkValue(titleValueController.text) -
        _checkValue(titleDiscountController.text) +
        _checkValue(titleFeesController.text);
    return TitleModel(
      id: widget.title?.id,
      name: titleNameController.text.trim(),
      description: titleDescriptionController.text.trim(),
      person: _personSelected!.id,
      type: _selectedTitleType == "Pagar"
          ? TitleType.obligation
          : TitleType.ownership,
      faceValue: _checkValue(titleValueController.text),
      discount: _checkValue(titleDiscountController.text),
      fees: _checkValue(titleFeesController.text),
      value: titleValue,
      qrp: widget.title?.qrp,
      status: widget.title?.status ?? TitleStatus.active,
      dueDate: titleDueDateController.text.isEmpty
          ? DateTimeAdapter().getDateNowBR()
          : titleDueDateController.text.trim(),
      createdAt: DateTimeAdapter().getDateTimeNowBR(),
      userCreate: widget.title?.userCreate,
    );
  }

  void _fillFields() {
    if (widget.title != null) {
      titleNameController.text = widget.title!.name!;
      titleValueController.text = widget.title!.faceValue.toString();
      titleDiscountController.text = widget.title!.discount.toString();
      titleFeesController.text = widget.title!.fees.toString();
      titleDueDateController.text =
          DateTimeAdapter().formatDateToBR(widget.title!.dueDate!);
      titleDescriptionController.text = widget.title!.description!;
      _selectedTitleType =
          widget.title!.type == TitleType.obligation ? "Pagar" : "Receber";
      _getPerson(); // Get person from database
    }
  }

  Future<void> _getPerson() async {
    final person = await widget.controller!.getPerson(widget.title!.person!);
    if (person != null) {
      setState(() {
        _personSelected = person;
        titlePersonController.text = _personSelected!.name!;
      });
    }
  }

  Future<void> _saveTitle(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (_selectedTitleType == null) {
        showCustomErrorDialog(
          context,
          "Selecione o tipo de título",
        );
        return;
      }

      if (!_checkTitleValue()) {
        showCustomErrorDialog(
          context,
          "O valor do desconto não pode ser maior que o valor do título",
        );
        return;
      }

      final title = _createTitle();

      if (widget.title == null) {
        await widget.controller!.createTitle(title);
      } else {
        await widget.controller!.updateTitle(title);
      }
      widget.onRefresh();
    }
  }

  @override
  void initState() {
    super.initState();
    _fillFields();
  }

  //////// Form fields
  TextFormField _titleNameField() {
    return TextFormField(
      controller: titleNameController,
      validator: Validators.validateGenericNotNull,
      maxLength: Validators.defaultTextNumCaracters,
      decoration: const InputDecoration(
        counterText: "",
        labelText: "Nome do Título",
        hintText: "Ex: Conta de Luz",
        prefixIcon: Icon(Icons.title),
      ),
    );
  }

  DateTextField _titleDueDateField() {
    return DateTextField(
      label: "Data de Vencimento",
      onDateSelected: (date) {
        titleDueDateController.text = date.toString();
      },
      dateState: true,
      initialDate: widget.title != null
          ? DateTimeAdapter().formatDateToBR(widget.title!.dueDate!)
          : DateTimeAdapter().getDateNowBR(),
    );
  }

  TextFormField _titleDescriptionField() {
    return TextFormField(
      controller: titleDescriptionController,
      maxLines: 2,
      maxLength: Validators.defaultLargeTextNumCaracters,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Descrição",
        prefixIcon: Icon(Icons.description),
      ),
    );
  }

  TextFormField _titlePersonField() {
    return TextFormField(
      controller: titlePersonController,
      validator: Validators.validateGenericNotNull,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Pessoa",
        prefixIcon: Icon(Icons.person),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => CustomSearchPerson(
            onPersonSelected: (person) {
              titlePersonController.text = person.name!;
              _personSelected = person;
            },
          ),
        );
      },
    );
  }

  DropdownButtonFormField<String> _titleTypeField() {
    return DropdownButtonFormField<String>(
      value: _selectedTitleType,
      items: _titleTypes
          .map((String type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedTitleType = value;
        });
      },
      decoration: const InputDecoration(
        labelText: "Tipo",
        prefixIcon: Icon(
          Icons.monetization_on,
        ),
      ),
    );
  }

  TextFormField _titleValueField() {
    return TextFormField(
      controller: titleValueController,
      validator: Validators.validateGenericNotNull,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\,?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        prefixText: "R\$ ",
        labelText: "Valor",
        prefixIcon: Icon(Icons.monetization_on),
      ),
    );
  }

  TextFormField _titleDiscountField() {
    return TextFormField(
      controller: titleDiscountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\,?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        prefixText: "R\$ ",
        labelText: "Desconto",
        prefixIcon: Icon(Icons.discount),
      ),
    );
  }

  TextFormField _titleFeesField() {
    return TextFormField(
      controller: titleFeesController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\,?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        prefixText: "R\$ ",
        labelText: "Juros",
        prefixIcon: Icon(Icons.money_off),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
            minWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Image.asset(
                          "assets/app/img/title_modal.gif",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 4,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.title == null
                                        ? "Novo Título"
                                        : "Editar Título",
                                    style: AppTextStyles.titleText,
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(child: _titleNameField()),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(child: _titleDueDateField()),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _titleDescriptionField(),
                            Row(
                              children: [
                                Expanded(
                                  child: _titlePersonField(),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: _titleTypeField(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Valores do Título:",
                                    style: AppTextStyles.titleTab,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.title != null,
                                  child: Row(
                                    children: [
                                      Text("Status: ${widget.title?.status}"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _titleValueField(),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: _titleDiscountField(),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: _titleFeesField(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomButtons(
                                buttonText: "Salvar",
                                textColor: Colors.white,
                                backgroundColor: AppColors.primaryRed,
                                width: 100,
                                onPressed: () => _saveTitle(context),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
