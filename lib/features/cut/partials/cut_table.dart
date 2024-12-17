// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/common/widgets/custom_choose_dialog.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/common/widgets/custom_error_dialog.dart';

import 'package:syscost/features/cut/cut_controller.dart';
import 'package:syscost/features/cut/partials/cut_modal.dart';

// ignore: must_be_immutable
class CutTable extends StatefulWidget {
  final CutController controller;
  final VoidCallback onCutAction;
  List? cutList;
  bool isLoading;

  CutTable({
    super.key,
    required this.controller,
    required this.onCutAction,
    required this.cutList,
    required this.isLoading,
  });

  @override
  State<CutTable> createState() => _CutTableState();
}

class _CutTableState extends State<CutTable> {
  void _showCutModal({required CutModel cutModal}) {
    if (cutModal.status != 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CutModal(
          controller: widget.controller,
          onCutAction: widget.onCutAction,
          cut: cutModal,
        ),
      );
    } else {
      showCustomErrorDialog(context, "O Corte já se encontra Fechado!");
    }
  }

  Future<void> _closeCut({required CutModel cut}) async {
    if (cut.status == 1) {
      showCustomErrorDialog(context, "O corte já se encontra fechado!");
      return;
    }

    final int userChoose = await CustomChooseDialog(
      context: context,
      message:
          "Deseja realmente fechar o corte ${cut.id}? Uma vez fechado o mesmo não pode ser mais alterado!",
      progressButton: "Sim",
      cancelMessage: "Cancelar",
    );

    if (userChoose == 1) {
      await widget.controller.closeCut(cut: cut);
      widget.onCutAction();
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
                          "Finalizado em",
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
                if (widget.cutList != null)
                  ...widget.cutList!.map(
                    (cut) {
                      return TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                cut.id.toString(),
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
                                cut.name,
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
                                cut.status == 1 ? "Finalizado" : "Em Andamento",
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
                                cut.completion ?? "Aberto",
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
                                      _showCutModal(cutModal: cut);
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
                                      _closeCut(cut: cut);
                                    },
                                    icon: Icon(
                                      Icons.power_settings_new,
                                      color: cut.status == 0
                                          ? AppColors.primaryGreen
                                          : AppColors.primaryRed,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {},
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
