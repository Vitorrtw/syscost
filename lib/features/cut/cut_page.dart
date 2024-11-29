import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/models/cut_itens_model.dart';
import 'package:syscost/common/widgets/drawer_menu.dart';

class CutPage extends StatefulWidget {
  const CutPage({super.key});

  @override
  State<CutPage> createState() => _CutPageState();
}

class _CutPageState extends State<CutPage> {
  final List<CutItensModel> itensList = [];

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
                            onPressed: () {},
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
