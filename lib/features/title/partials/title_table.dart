import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/title_model.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';

class TitleTable extends StatelessWidget {
  final List titles;
  final bool isLoading;
  final Function(TitleModel) onEdit;
  final Function(TitleModel) onToggleStatus;
  final Function(TitleModel) onDelete;

  const TitleTable({
    super.key,
    required this.titles,
    this.isLoading = false,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
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
                          "Tipo",
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
                          "Valor",
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
                if (titles.isNotEmpty)
                  ...titles.map((title) {
                    return TableRow(
                      children: [
                        TableCell(
                            child: Text(
                          title.id?.toString() ?? "",
                          style: AppTextStyles.defaultText,
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                            child: Text(
                          title.name ?? "",
                          style: AppTextStyles.defaultText,
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                            child: Text(
                          title.status?.description ?? "",
                          style: AppTextStyles.defaultText,
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                            child: Text(
                          title.type?.code == 1 ? "Direito" : "Obrigação",
                          style: AppTextStyles.defaultText,
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                            child: Text(
                          "R\$ ${title.value.toString().replaceAll('.', ',')}",
                          style: AppTextStyles.defaultText.copyWith(
                            color: title.type?.code == 1
                                ? AppColors.primaryGreen
                                : AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => onEdit(title),
                                  icon: const Icon(
                                    Icons.edit_document,
                                    color: AppColors.primaryDarkGray,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () => onToggleStatus(title),
                                  icon: const Icon(
                                    Icons.power_settings_new,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () => onDelete(title),
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
                  }),
              ],
            ),
          );
  }
}
