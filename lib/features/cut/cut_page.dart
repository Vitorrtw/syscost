// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/common/widgets/custom_error_dialog.dart';
import 'package:syscost/common/widgets/custom_success_dialog.dart';
import 'package:syscost/common/widgets/drawer_menu.dart';
import 'package:syscost/features/cut/cut_controller.dart';
import 'package:syscost/features/cut/cut_state.dart';
import 'package:syscost/features/cut/partials/cut_modal.dart';
import 'package:syscost/features/cut/partials/cut_table.dart';
import 'package:syscost/locator.dart';

class CutPage extends StatefulWidget {
  const CutPage({super.key});

  @override
  State<CutPage> createState() => _CutPageState();
}

class _CutPageState extends State<CutPage> {
  // Local values
  List? cutList;
  bool isLoading = true;

  // Controller Page
  final _pageController = locator.get<CutController>();

  @override
  void initState() {
    _pageController.addListener(_handlePersonStateChange);
    _getCuts();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _getCuts() async {
    final custDataLits = await _pageController.getCuts();
    setState(() {
      cutList = custDataLits;
      isLoading = false;
    });
  }

  void _showCutModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CutModal(
        controller: _pageController,
        onCutAction: _getCuts,
      ),
    );
  }

  void _handlePersonStateChange() {
    switch (_pageController.state.runtimeType) {
      case CutStateLoading:
        showDialog(
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
        break;
      case CutStateError:
        showCustomErrorDialog(
            context, (_pageController.state as CutStateError).error);
        break;
      case CutStateSuccess:
        Navigator.pop(context);
        showCustomSuccessDialog(
            context, (_pageController.state as CutStateSuccess).message!);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: Text(
          "SisCont",
          style:
              AppTextStyles.titleText.copyWith(color: AppColors.primaryWhite),
        ),
      ),
      drawer: const DrawerMenu(),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: const BoxDecoration(
              color: AppColors.primaryWhite,
              border: Border(
                right: BorderSide(color: AppColors.primaryRed, width: 5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/app/img/cut_page.gif",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 0.23,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed),
                            onPressed: _showCutModal,
                            child: Text(
                              "Cadastrar",
                              style: AppTextStyles.buttonText
                                  .copyWith(color: AppColors.primaryWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Tabela de Cortes",
                        style: AppTextStyles.titleText,
                      ),
                    ),
                    CutTable(
                      controller: _pageController,
                      onCutAction: _getCuts,
                      cutList: cutList,
                      isLoading: isLoading,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
