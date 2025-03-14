import 'package:flutter/material.dart';
import 'package:syscost/common/constants/tables_names.dart';
import 'package:syscost/common/models/title_model.dart';
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
}
