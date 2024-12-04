// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/constants/app_text_styles.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/common/widgets/custom_error_dialog.dart';
import 'package:syscost/common/widgets/custom_success_dialog.dart';
import 'package:syscost/common/widgets/drawer_menu.dart';
import 'package:syscost/features/person/partials/person_modal.dart';
import 'package:syscost/features/person/partials/person_table.dart';
import 'package:syscost/features/person/person_controller.dart';
import 'package:syscost/features/person/person_state.dart';
import 'package:syscost/locator.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  // Local values
  List? personList;
  bool isLoading = true;

  // Page Controller
  final _pageController = locator.get<PersonController>();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePersonStateChange);
    _getPerson();
  }

  void _handlePersonStateChange() {
    switch (_pageController.state.runtimeType) {
      case PersonStateLoading:
        showDialog(
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
        break;
      case PersonStateError:
        showCustomErrorDialog(
            context, (_pageController.state as PersonStateError).error);
        break;
      case PersonStateSuccess:
        Navigator.pop(context);
        showCustomSuccessDialog(
            context, (_pageController.state as PersonStateSuccess).message!);
        break;
      case PersonStateStatic:
        break;
    }
  }

  Future<void> _getPerson() async {
    final userDataList = await _pageController.getPersons();
    setState(() {
      personList = userDataList;
      isLoading = false;
    });
  }

  void _showPersonModal() {
    showDialog(
      context: context,
      builder: (context) => PersonModal(
        onPersonAction: _getPerson,
        personController: _pageController,
      ),
    );
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
                    "assets/app/img/person.gif",
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
                              backgroundColor: AppColors.primaryRed,
                            ),
                            onPressed: () {
                              _showPersonModal();
                            },
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
                        "Pessoas cadastradas",
                        style: AppTextStyles.titleText,
                      ),
                    ),
                    PersonTable(
                      controller: _pageController,
                      isLoading: isLoading,
                      personList: personList,
                      onPersonAction: _getPerson,
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
