import 'package:flutter/material.dart';
import 'package:syscost/common/constants/tables_names.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/features/person/person_state.dart';
import 'package:syscost/services/data_services.dart';

class PersonController extends ChangeNotifier {
  final DataServices _dataServices;

  PersonController({required DataServices dataService})
      : _dataServices = dataService;

  PersonState _state = PersonStateInitial();

  PersonState get state => _state;

  Future<List?> getPersons() async {
    final personsDataList =
        await _dataServices.queryData(tableName: "SYS_PERSONS");

    if (personsDataList.error != null) {
      _changeState(PersonStateError(personsDataList.error!.message));
      return null;
    }

    List personList = personsDataList.data.map(PersonModel.fromDb).toList();
    return personList;
  }

  Future<List?> getActivePersons() async {
    try {
      final personDataList = await _dataServices.getWhere(
          tableName: TablesNames.persons, where: "STATUS = 1");

      if (personDataList.error != null) {
        throw Exception(personDataList.error?.message);
      }
      List personList = personDataList.data.map(PersonModel.fromDb).toList();
      return personList;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List?> getPersonsByName({required String userName}) async {
    try {
      final personDataList = await _dataServices.getWhere(
          tableName: TablesNames.persons, where: "NAME LIKE '%$userName%' ");

      if (personDataList.error != null) {
        throw Exception(personDataList.error?.message);
      }

      List personsList = personDataList.data.map(PersonModel.fromDb).toList();
      return personsList;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> alterPersonStatus({required PersonModel person}) async {
    _changeState(PersonStateLoading());
    final int status = person.status == 0 ? 1 : 0;
    final DataResult response = await _dataServices.updateData(
        tableName: TablesNames.persons,
        data: {"STATUS": status},
        where: "ID = ${person.id}");

    response.fold(
      (error) => _changeState(PersonStateError(error.message)),
      (data) {
        _changeState(PersonStateSuccess("Pessoa Alterada!"));
      },
    );
  }

  Future<void> deletePerson({required PersonModel person}) async {
    _changeState(PersonStateLoading());
    final DataResult response = await _dataServices.deleteWhere(
        tableName: TablesNames.persons, where: "ID = ${person.id}");

    response.fold(
      (error) => _changeState(PersonStateError(error.message)),
      (data) =>
          _changeState(PersonStateSuccess("Pessoa deletada com sucesso!")),
    );
  }

  Future<void> createPerson({
    required PersonModel person,
  }) async {
    _changeState(PersonStateLoading());
    final DataResult response = await _dataServices.insertData(
      tableName: TablesNames.persons,
      data: person.toMap(),
    );

    response.fold(
      (error) => _changeState(PersonStateError(error.message)),
      (data) =>
          _changeState(PersonStateSuccess("Pessoa cadastrada com sucesso!")),
    );
  }

  Future<void> alterPersonData({
    required PersonModel person,
  }) async {
    _changeState(PersonStateLoading());
    final DataResult response = await _dataServices.updateData(
        tableName: TablesNames.persons,
        data: person.toMap(),
        where: "ID = ${person.id}");

    response.fold(
      (error) => _changeState(PersonStateError(error.message)),
      (data) =>
          _changeState(PersonStateSuccess("Cadastro alterado com secesso!")),
    );
  }

  void _changeState(PersonState newState) {
    _state = newState;
    notifyListeners();
  }
}
