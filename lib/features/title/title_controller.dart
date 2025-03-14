import 'package:flutter/material.dart';
import 'package:syscost/common/constants/tables_names.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/models/title_model.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/features/title/title_state.dart';
import 'package:syscost/services/data_services.dart';
import 'package:syscost/services/secure_storage.dart';

class TitleController extends ChangeNotifier {
  final DataServices _dataServices;
  final SecuredStorage _securedStorage;

  TitleController({
    required DataServices dataService,
    required SecuredStorage securedStorage,
  })  : _dataServices = dataService,
        _securedStorage = securedStorage;

  TitleState _state = TitleStateInitial();

  TitleState get state => _state;

  void _changeState(TitleState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<List?> getTitles() async {
    try {
      final response =
          await _dataServices.queryData(tableName: TablesNames.titles);

      return response.fold(
        (error) {
          _changeState(TitleStateError(error.message));
          return null;
        },
        (data) {
          List titles = data.map((e) => TitleModel.fromDb(e)).toList();
          return titles;
        },
      );
    } catch (e) {
      _changeState(TitleStateError(e.toString()));
      return null;
    }
  }

  Future<PersonModel?> getPerson(int personId) async {
    final response = await _dataServices.getWhere(
      tableName: TablesNames.persons,
      where: "ID = $personId",
    );

    return response.fold(
      (error) {
        _changeState(TitleStateError(error.message));
        return null;
      },
      (data) {
        return PersonModel.fromDb(data.first);
      },
    );
  }

  Future<void> createTitle(TitleModel title) async {
    try {
      _changeState(TitleStateLoading());
      final user = await _getCurrentUser();
      title.userCreate = user.id; // Set user create

      final qrp = await _dataServices.getSequence(sequence: Sequence.qrp);

      title.qrp = qrp.data; // Set QRP

      final response = await _dataServices.insertData(
        tableName: TablesNames.titles,
        data: title.toMap(),
      );

      response.fold(
        (error) {
          _changeState(TitleStateError(error.message));
        },
        (_) {
          _changeState(TitleStateSuccess("Título criado com sucesso"));
        },
      );
    } catch (e) {
      _changeState(TitleStateError(e.toString()));
    }
  }

  Future<void> updateTitle(TitleModel title) async {
    try {
      _changeState(TitleStateLoading());
      final response = await _dataServices.updateData(
        tableName: TablesNames.titles,
        data: title.toMap(),
        where: "ID = ${title.id}",
      );

      response.fold(
        (error) {
          _changeState(TitleStateError(error.message));
        },
        (_) {
          _changeState(TitleStateSuccess("Título atualizado com sucesso"));
        },
      );
    } catch (e) {
      _changeState(TitleStateError(e.toString()));
    }
  }

  Future<UserModel> _getCurrentUser() async {
    String? userData = await _securedStorage.readOne(key: "CURRENT_USER");
    if (userData != null) {
      UserModel currentUser = UserModel.fromJson(userData);
      return currentUser;
    } else {
      throw Exception("Erro: User not find");
    }
  }
}
