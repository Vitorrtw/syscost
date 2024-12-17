import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/utils/functions.dart';
import 'package:syscost/common/utils/validators.dart';
import 'package:syscost/common/widgets/custom_error_dialog.dart';
import 'package:syscost/common/widgets/custom_search_person.dart';
import 'package:syscost/common/widgets/custom_table_head_cell.dart';
import 'package:syscost/features/cut/cut_controller.dart';

class CutModal extends StatefulWidget {
  final VoidCallback onCutAction;
  final CutModel? cut;
  final CutController controller;

  const CutModal({
    super.key,
    required this.onCutAction,
    this.cut,
    required this.controller,
  });

  @override
  State<CutModal> createState() => _CutModalState();
}

class _CutModalState extends State<CutModal> {
  final _cutFormKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _rows = [];
  bool _generateTitle = false;
  PersonModel? _personTitle;

  // Text Controllers
  final _personTitleController = TextEditingController();
  final _cutNameController = TextEditingController();
  final _titleValueController = TextEditingController();

  void _addRow() {
    setState(() {
      _rows.add({
        "color": "",
        "sizes": {
          "P": 0,
          "M": 0,
          "G": 0,
          "GG": 0,
          "GG1": 0,
          "GG2": 0,
          "GG3": 0,
          "GG4": 0
        },
        "total": 0,
      });
    });
  }

  @override
  void initState() {
    _getCutItens();
    super.initState();
  }

  void _removeRow(int index) {
    setState(() {
      _rows.removeAt(index);
    });
  }

  Future<void> _getCutItens() async {
    if (widget.cut != null) {
      _cutNameController.text = widget.cut!.name!;
      final response =
          await widget.controller.getCutItens(cutId: widget.cut!.id!);

      setState(() {
        _rows = response!;
      });
    }
  }

  void _updateTotal(int index) {
    final sizes = (_rows[index]["sizes"] as Map).cast<String, int>();
    setState(() {
      _rows[index]["total"] = sizes.values.fold(0, (sum, value) => sum + value);
    });
  }

  void _handlePersonSelected(PersonModel person) {
    setState(() {
      _personTitle = person;
      _personTitleController.text = person.name!;
    });
  }

  Future<void> _createCut() async {
    // Cut Validators
    if (_cutFormKey.currentState!.validate()) {
      if (_rows.isEmpty) {
        showCustomErrorDialog(context, "O corte não possui item Cadastrado!");
        return;
      }

      if (_generateTitle && _personTitle == null) {
        showCustomErrorDialog(
            context, "Nenhuma pessoa selecionada para geração do titulo!");
        return;
      }

      if (_titleValueController.text.isEmpty && _generateTitle) {
        showCustomErrorDialog(
            context, "Favor selecione uma valor para o titulo");
        return;
      }

      await widget.controller.createCut(
        cutItensData: _rows,
        cutName: _cutNameController.text,
        generateTitle: _generateTitle,
        person: _personTitle,
        titleValue: _titleValueController.text.isEmpty
            ? null
            : double.parse(_titleValueController.text.replaceAll(",", ".")),
      );
      widget.onCutAction();
    }
  }

  Future<void> _alterCut() async {
    if (_cutFormKey.currentState!.validate()) {
      if (_rows.isEmpty) {
        showCustomErrorDialog(context, "O corte não possui item Cadastrado!");
        return;
      }
      await widget.controller.alterCut(
        cutId: widget.cut!.id!,
        cutName: _cutNameController.text,
        cutItens: _rows,
        cutStatus: widget.cut!.status!,
        completion: widget.cut!.completion,
        userCreate: widget.cut!.userCreate!,
        userFinished: widget.cut!.userFinished,
      );
    }
    widget.onCutAction();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 900,
          ),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _cutFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/app/img/person_create.gif",
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _addRow,
                                icon: const Icon(Icons.add),
                                label: const Text("Adicionar"),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.cut == null
                                      ? "Cadastrar Corte"
                                      : "Alterar Corte",
                                  style: AppTextStyles.titleText,
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.primaryRed,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _cutNameController,
                              validator: Validators.validateGenericNotNull,
                              maxLength: 65,
                              decoration: const InputDecoration(
                                labelText: "Nome do Corte",
                                hintText: "Digite o Nome do Corte",
                                prefixIcon: Icon(
                                  Icons.note_alt_rounded,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Lista de Itens:",
                                    style: AppTextStyles.titleTab,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.cut == null,
                                  child: Checkbox(
                                    value: _generateTitle,
                                    activeColor: AppColors.primaryRed,
                                    onChanged: (value) {
                                      setState(() {
                                        _generateTitle = value!;
                                      });
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: widget.cut == null,
                                  child: const Text(
                                    "Gerar Titulo?",
                                    style: AppTextStyles.defaultText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Table(
                    border: TableBorder.all(color: AppColors.primaryRed),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: AppColors.primaryRed),
                        children: [
                          CustomTableHeadCell(text: "Cor"),
                          CustomTableHeadCell(text: "P"),
                          CustomTableHeadCell(text: "M"),
                          CustomTableHeadCell(text: "G"),
                          CustomTableHeadCell(text: "GG"),
                          CustomTableHeadCell(text: "GG1"),
                          CustomTableHeadCell(text: "GG2"),
                          CustomTableHeadCell(text: "GG3"),
                          CustomTableHeadCell(text: "GG4"),
                          CustomTableHeadCell(text: "Total"),
                          CustomTableHeadCell(text: "Ação"),
                        ],
                      ),
                      ..._rows.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> row = entry.value;
                        return TableRow(
                          children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                validator: Validators.validateGenericNotNull,
                                textAlign: TextAlign.center,
                                initialValue: row["color"],
                                decoration:
                                    const InputDecoration(hintText: "Cor"),
                                onChanged: (value) {
                                  row["color"] = toTitleCase(value);
                                },
                              ),
                            ),
                            ...["P", "M", "G", "GG", "GG1", "GG2", "GG3", "GG4"]
                                .map((size) {
                              return TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: TextFormField(
                                  initialValue:
                                      row["sizes"][size]?.toString() ?? "0",
                                  maxLength: 3,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      hintText: "0", counterText: ""),
                                  onChanged: (value) {
                                    row["sizes"][size] =
                                        int.tryParse(value) ?? 0;
                                    _updateTotal(index);
                                  },
                                ),
                              );
                            }),
                            TableCell(
                              child: Text(
                                row["total"].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TableCell(
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: AppColors.primaryRed),
                                onPressed: () => _removeRow(index),
                              ),
                            ),
                          ],
                        );
                      })
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: _generateTitle,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Dados do titulo",
                          style: AppTextStyles.titleTab,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CustomSearchPerson(
                                    onPersonSelected: _handlePersonSelected,
                                  ),
                                );
                              },
                              child: const Text(
                                "Buscar",
                                style: AppTextStyles.buttonText,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 5,
                              child: TextField(
                                controller: _personTitleController,
                                enabled: false,
                                decoration: const InputDecoration(
                                  prefixText: "Pessoa:  ",
                                  prefixIcon: Icon(
                                    Icons.person,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _titleValueController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+[,|.]?\d{0,2}$')),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    final newText =
                                        newValue.text.replaceAll('.', ',');
                                    return newValue.copyWith(
                                        text: newText,
                                        selection: newValue.selection);
                                  })
                                ],
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryGreen,
                                  ),
                                  prefixText: "R\$ ",
                                  labelText: "Valor",
                                  hintText: "Digite o valor do titulo",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //// Button create
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                      ),
                      onPressed: () {
                        if (widget.cut == null) {
                          _createCut();
                        } else {
                          _alterCut();
                        }
                      },
                      child: Text(
                        widget.cut == null ? "Gerar corte" : "Alterar corte",
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
