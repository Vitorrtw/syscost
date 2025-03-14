import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/title_model.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/features/title/title_controller.dart';

class TitleTable extends StatefulWidget {
  final TitleController controller;

  const TitleTable({
    super.key,
    required this.controller,
  });

  @override
  State<TitleTable> createState() => _TitleTableState();
}

class _TitleTableState extends State<TitleTable> {
  bool _isLoading = false;
  List _titles = [];

  Future<void> _getTitles() async {
    final titleList = await widget.controller.getTitles();
    setState(() {
      _titles = titleList ?? [];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTitles();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
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
                if (_titles.isNotEmpty)
                  ..._titles.map((title) {
                    return TableRow(
                      children: [
                        TableCell(
                            child: Text(
                          title.id.toString(),
                          style: AppTextStyles.defaultText,
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                            child: Text(
                          title.name,
                          style: AppTextStyles.defaultText,
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                            child: Text(
                          title.status.description,
                          style: AppTextStyles.defaultText,
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                            child: Text(
                          title.type.code == 1 ? "Direito" : "Obrigação",
                          style: AppTextStyles.defaultText,
                          textAlign: TextAlign.center,
                        )),
                        TableCell(
                            child: Text(
                          "R\$ ${title.value.toString().replaceAll('.', ',')}",
                          style: AppTextStyles.defaultText.copyWith(
                            color: title.type.code == 1
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
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit_document,
                                    color: AppColors.primaryDarkGray,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.power_settings_new,
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
                  }),
              ],
            ),
          );
  }
}
