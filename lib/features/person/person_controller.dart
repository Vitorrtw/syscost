import 'package:flutter/material.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/features/person/person_state.dart';
import 'package:syscost/services/data_services.dart';

class PersonController extends ChangeNotifier {
  final DataServices _dataServices;
  static const String tableName = "SYS_PERSONS";

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

    List personList = personsDataList.data.map(_createPersonModel).toList();
    return personList;
  }

  Future<void> alterPersonStatus({required PersonModel person}) async {
    _changeState(PersonStateLoading());
    final int status = person.status == 0 ? 1 : 0;
    final DataResult response = await _dataServices.updateData(
        tableName: "SYS_PERSONS",
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
        tableName: tableName, where: "ID = ${person.id}");

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
      tableName: tableName,
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
        tableName: tableName, data: person.toMap(), where: "ID = ${person.id}");

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

  PersonModel _createPersonModel(Map<String, dynamic> personData) {
    return PersonModel(
        id: personData["ID"],
        name: personData["NAME"],
        status: personData["STATUS"],
        tell: personData["TELL"],
        address: personData["ADDRESS"],
        number: personData["NUMBER"],
        district: personData["DISTRICT"],
        city: personData["CITY"],
        cep: personData["CEP"],
        uf: personData["UF"]);
  }
}
