// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/title_model.dart';
import 'package:syscost/common/widgets/custom_appbar.dart';
import 'package:syscost/common/widgets/custom_buttons.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/common/widgets/custom_error_dialog.dart';
import 'package:syscost/common/widgets/custom_side_painel.dart';
import 'package:syscost/common/widgets/custom_success_dialog.dart';
import 'package:syscost/common/widgets/drawer_menu.dart';
import 'package:syscost/features/title/partials/title_modal.dart';
import 'package:syscost/features/title/partials/title_table.dart';
import 'package:syscost/features/title/title_controller.dart';
import 'package:syscost/features/title/title_state.dart';
import 'package:syscost/locator.dart';

class TitlePage extends StatefulWidget {
  const TitlePage({super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  // Page controller
  final TitleController _controller = locator.get<TitleController>();

  // Page States
  bool _isLoading = false;
  List _titles = [];

  void _handleTitleStateChange() {
    switch (_controller.state.runtimeType) {
      case TitleStateLoading:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
        break;
      case TitleStateError:
        Navigator.of(context).pop();
        showCustomErrorDialog(
            context, (_controller.state as TitleStateError).message);
        break;
      case TitleStateSuccess:
        Navigator.of(context).pop();
        showCustomSuccessDialog(
            context, (_controller.state as TitleStateSuccess).message);
        break;
    }
  }

  void _showTitleModal(TitleModel? title) {
    showDialog(
      context: context,
      builder: (context) => TitleModal(
        title: title,
        controller: _controller,
        onRefresh: _getTitles,
      ),
    );
  }

  Future<void> _getTitles() async {
    setState(() {
      _isLoading = true;
    });

    final titles = await _controller.getTitles();
    setState(() {
      _titles = titles ?? [];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTitleStateChange);
    _getTitles();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTitleStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      drawer: const DrawerMenu(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    CustomSidePainel(
                      buttonText: "Criar Titulo",
                      imagePath: "assets/app/img/title_page.gif",
                      child: _buttonsColumn(),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Tabela de titulos",
                              style: AppTextStyles.titleText,
                            ),
                          ),
                          TitleTable(
                            titles: _titles,
                            isLoading: _isLoading,
                            onEdit: _showTitleModal,
                            onToggleStatus: (p0) {},
                            onDelete: (p0) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //////////////////// Partial Widgets ////////////////////

  Widget _buttonsColumn() {
    return Column(
      children: [
        CustomButtons(
          buttonText: "Criar Titulo",
          onPressed: () => _showTitleModal(null),
          textColor: AppColors.primaryWhite,
          backgroundColor: AppColors.primaryRed,
          width: double.infinity,
        ),
      ],
    );
  }
}
