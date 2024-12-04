import 'package:flutter/material.dart';
import 'package:syscost/common/constants/app_colors.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/widgets/custom_circular_progress_indicator.dart';
import 'package:syscost/common/widgets/custom_error_widget.dart';
import 'package:syscost/features/person/person_controller.dart';
import 'package:syscost/locator.dart';

class CustomSearchPerson extends StatefulWidget {
  final Function(PersonModel selectedPerson) onPersonSelected;
  const CustomSearchPerson({
    super.key,
    required this.onPersonSelected,
  });

  @override
  State<CustomSearchPerson> createState() => _CustomSearchPersonState();
}

class _CustomSearchPersonState extends State<CustomSearchPerson> {
  final _personController = locator.get<PersonController>();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _persons = [];
  bool _isLoading = false;
  String? _error;

  /// Person selected

  Future<void> _searchPersons(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response =
          await _personController.getPersonsByName(userName: query);
      setState(() {
        _persons = response!;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getActivePersons() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _personController.getActivePersons();
      setState(() {
        _persons = response!;
      });
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    _getActivePersons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 800,
          ),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input and Button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: "Pesquisar por nome",
                          hintText: "Digite o nome da pessoa",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final query = _searchController.text.trim();

                        _searchPersons(query);
                      },
                      child: const Text("Buscar"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Loading Indicator
                if (_isLoading) const CustomCircularProgressIndicator(),

                // Error Message
                if (_error != null) CustomErrorWidget(errorMessage: _error!),

                // List of Persons
                if (!_isLoading && _error == null)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (__, _) => const Divider(),
                    itemCount: _persons.isEmpty ? 1 : _persons.length,
                    itemBuilder: (context, index) {
                      if (_persons.isEmpty) {
                        return const ListTile(
                          title: Text("Nenhum resultado encontrado."),
                        );
                      }
                      final person = _persons[index];
                      return ListTile(
                        title: Text("${person.name}"),
                        trailing: const Icon(
                          Icons.ads_click,
                          color: AppColors.primaryGreen,
                        ),
                        onTap: () {
                          widget.onPersonSelected(person);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
