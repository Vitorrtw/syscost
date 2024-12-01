import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/common/utils/validators.dart';
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
  static const List<DropdownMenuItem<int>> sizeList = [
    DropdownMenuItem<int>(value: 1, child: Text("PP")),
    DropdownMenuItem<int>(value: 2, child: Text("P")),
    DropdownMenuItem<int>(value: 3, child: Text("M")),
    DropdownMenuItem<int>(value: 4, child: Text("G")),
  ];
  final List<Map<String, TextEditingController>> controllers = [];

  void _addCutItem() {
    setState(() {
      controllers.add({
        "color": TextEditingController(),
        "size": TextEditingController(),
        "quantity": TextEditingController(),
      });
    });
  }

  void _removeCutItem(int index) {
    setState(() {
      controllers.removeAt(index);
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
            maxWidth: 800,
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
                                onPressed: _addCutItem,
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
                            Text(
                              widget.cut == null
                                  ? "Cadastrar Corte"
                                  : "Alterar Corte",
                              style: AppTextStyles.titleText,
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
                            const Text(
                              "Lista de Itens:",
                              style: AppTextStyles.titleTab,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  ...controllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controllerMap = entry.value;

                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controllerMap["color"],
                            decoration: const InputDecoration(
                              labelText: "Cor",
                              hintText: "Digite a cor",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              border: UnderlineInputBorder(),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: sizeList,
                                value: int.tryParse(
                                    controllerMap["size"]?.text ?? ""),
                                onChanged: (value) {
                                  setState(() {
                                    controllerMap["size"]?.text =
                                        value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: controllerMap["quantity"],
                            decoration: const InputDecoration(
                              labelText: "Quantidade",
                              hintText: "Digite a quantidade",
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeCutItem(index),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
