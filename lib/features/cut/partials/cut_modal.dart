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

  List<Map<String, String>> cutItens = [];

  final _cutNameController = TextEditingController();

  void _addCutIten() {
    setState(() {
      cutItens.add({"color": "", "size": "", "quantity": ""});
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
                                onPressed: _addCutIten,
                                icon: Icon(Icons.add),
                                label: Text("Adicionar"),
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
                            const Text(
                              "Lista de Itens:",
                              style: AppTextStyles.titleTab,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  ...cutItens.map((itens) {
                    final sizeController = TextEditingController(
                      text: itens["size"],
                    );
                    final colorController = TextEditingController(
                      text: itens["color"],
                    );
                    final quantityController =
                        TextEditingController(text: itens["quantity"]);

                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: colorController,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: sizeController,
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
