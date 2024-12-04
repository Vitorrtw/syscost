import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/utils/validators.dart';
import 'package:syscost/common/widgets/custom_search_person.dart';
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
  final List<Map<String, dynamic>> _rows = [];
  bool _generateTitle = false;
  PersonModel? _personTitle;

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

  void _removeRow(int index) {
    setState(() {
      _rows.removeAt(index);
    });
  }

  void _updateTotal(int index) {
    final sizes = _rows[index]["sizes"] as Map<String, int>;
    setState(() {
      _rows[index]["total"] = sizes.values.reduce((a, b) => a + b);
    });
  }

  void _handlePersonSelected(PersonModel person) {
    setState(() {
      _personTitle = person;
    });
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
                              controller: TextEditingController(),
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
                                Checkbox(
                                  value: _generateTitle,
                                  activeColor: AppColors.primaryRed,
                                  onChanged: (value) {
                                    setState(() {
                                      _generateTitle = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  "Gerar Titulo?",
                                  style: AppTextStyles.defaultText,
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
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Cor",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "P",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "M",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "G",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "GG",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "GG1",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "GG2",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "GG3",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "GG4",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Total",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Ação",
                                style: AppTextStyles.titleTab,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
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
                                decoration:
                                    const InputDecoration(hintText: "Cor"),
                                onChanged: (value) {
                                  row["color"] = value;
                                },
                              ),
                            ),
                            ...["P", "M", "G", "GG", "GG1", "GG2", "GG3", "GG4"]
                                .map((size) {
                              return TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: TextFormField(
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
                            Text(
                              "Pessoa: ",
                              style: AppTextStyles.titleTab,
                            ),
                            Text(
                              _personTitle == null
                                  ? "Selecione uma Pessoa"
                                  : _personTitle!.name!,
                              style: AppTextStyles.defaultText,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Expanded(
                              flex: 3,
                              child: TextField(
                                decoration: InputDecoration(
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
                  SizedBox(
                    height: 20,
                  ),
                  //// Button create
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Gerar corte",
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
