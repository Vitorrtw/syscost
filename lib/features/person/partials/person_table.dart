// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/widgets/custom_choose_dialog.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/features/person/partials/person_modal.dart';

import 'package:syscost/features/person/person_controller.dart';

// ignore: must_be_immutable
class PersonTable extends StatefulWidget {
  final PersonController controller;
  final VoidCallback onPersonAction;
  List? personList;
  bool isLoading;

  PersonTable({
    super.key,
    required this.controller,
    required this.onPersonAction,
    required this.personList,
    required this.isLoading,
  });

  @override
  State<PersonTable> createState() => _PersonTableState();
}

class _PersonTableState extends State<PersonTable> {
  void _showPersonModal({
    required PersonModel person,
  }) {
    showDialog(
      context: context,
      builder: (context) => PersonModal(
        onPersonAction: widget.onPersonAction,
        personController: widget.controller,
        person: person,
      ),
    );
  }

  Future<void> _alterPersonStatus({
    required PersonModel person,
  }) async {
    final userChoose = await CustomChooseDialog(
        context: context,
        message:
            "Deseja realmente ${person.status == 0 ? "Ativar" : "Desativar"} a Pessoa ${person.name} ?",
        progressButton: "Sim",
        cancelMessage: "Cancelar");
    if (userChoose == 1) {
      await widget.controller.alterPersonStatus(person: person).then(
        (_) {
          widget.onPersonAction();
        },
      );
    }
  }

  Future<void> _deletePerson({
    required PersonModel person,
  }) async {
    final userChoose = await CustomChooseDialog(
        context: context,
        message: "Deseja realmente excluir a pessoa ${person.name} ?",
        progressButton: "Sim",
        cancelMessage: "Cancelar");

    if (userChoose == 1) {
      await widget.controller.deletePerson(person: person).then(
        (_) {
          widget.onPersonAction();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? const Center(
            child: CustomCircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Table(
              border: TableBorder.all(color: AppColors.primaryRed),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: AppColors.primaryRed),
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "ID",
                          style: AppTextStyles.titleTab,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Nome",
                          style: AppTextStyles.titleTab,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Status",
                          style: AppTextStyles.titleTab,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Ações",
                          style: AppTextStyles.titleTab,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.personList != null)
                  ...widget.personList!.map(
                    (person) {
                      return TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                person.id.toString(),
                                style: AppTextStyles.defaultText,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                person.name,
                                style: AppTextStyles.defaultText,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                person.status == 1 ? "Ativo" : "Inativo",
                                style: AppTextStyles.defaultText,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _showPersonModal(person: person);
                                    },
                                    icon: const Icon(
                                      Icons.edit_document,
                                      color: AppColors.primaryDarkGray,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _alterPersonStatus(person: person);
                                    },
                                    icon: Icon(
                                      Icons.power_settings_new,
                                      color: person.status == 1
                                          ? AppColors.primaryGreen
                                          : AppColors.primaryRed,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deletePerson(person: person);
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
              ],
            ),
          );
  }
}
