import 'package:flutter/material.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/features/user/user_state.dart';
import 'package:syscost/services/data_services.dart';

class UserController extends ChangeNotifier {
  final DataServices _dataServices;

  UserController({required DataServices dataService})
      : _dataServices = dataService;

  UserState _state = UserStateInitial();

  UserState get state => _state;

  void _changeState(UserState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<List?> getUsers() async {
    final userData = await _dataServices.queryData(tableName: "SYS_USERS");

    if (userData.error != null) {
      _changeState(UserStateError(userData.error!.message));
      return null;
    }

    return userData.data;
  }

  Future<void> deleteUser(int userId) async {
    _changeState(UserStateLoading());
    final DataResult response = await _dataServices.deleteWhere(
        tableName: "SYS_USERS", where: "ID = $userId");

    response.fold(
      (error) {
        _changeState(UserStateError(error.message));
      },
      (data) {
        _changeState(UserStateSuccess("Usuario excluido com sucesso!"));
      },
    );
  }

  Future<void> deactivateUser(int userId) async {
    _changeState(UserStateLoading());
  }
}
