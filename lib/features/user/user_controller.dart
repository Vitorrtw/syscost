import 'package:flutter/material.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/features/user/user_state.dart';
import 'package:syscost/services/data_services.dart';

class UserController extends ChangeNotifier {
  final DataServices _dataServices;

  UserController({required DataServices dataService})
      : _dataServices = dataService;

  UserState _state = UserStateInitial();

  UserState get state => _state;

  Future<List?> getUsers() async {
    final userData = await _dataServices.queryData(tableName: "SYS_USERS");

    if (userData.error != null) {
      _changeState(UserStateError(userData.error!.message));
      return null;
    }

    List userList = userData.data.map(_createUserModel).toList();
    return userList;
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

  Future<void> alterUserData({
    required UserModel user,
  }) async {
    final DataResult response = await _dataServices.updateData(
        tableName: "SYS_USERS",
        data: {
          "LOGIN": user.login,
          "NAME": user.name,
          "PASSWORD": user.password,
        },
        where: "ID = ${user.id}");

    response.fold(
      (error) => _changeState(UserStateError(error.message)),
      (data) => _changeState(UserStateSuccess("Usuario Alterado com Sucesso!")),
    );
  }

  Future<void> alterUserStatus({
    required int userId,
    required int currentStatus,
  }) async {
    _changeState(UserStateLoading());
    final int status = currentStatus == 0 ? 1 : 0;
    final DataResult response = await _dataServices.updateData(
        tableName: "SYS_USERS",
        data: {"STATUS": status},
        where: "ID = $userId");

    response.fold(
      (error) => _changeState(UserStateError(error.message)),
      (data) => _changeState(UserStateSuccess("Usuario Alterado!")),
    );
  }

  Future<void> createUser({
    required UserModel user,
  }) async {
    final DataResult response = await _dataServices.insertData(
      tableName: "SYS_USERS",
      data: {
        "LOGIN": user.login,
        "NAME": user.name,
        "PASSWORD": user.password,
        "STATUS": 1,
      },
    );

    response.fold(
      (error) => _changeState(
        UserStateError(error.message),
      ),
      (data) => _changeState(
        UserStateSuccess("Usuario Cadastrado com Sucesso!"),
      ),
    );
  }

  void _changeState(UserState newState) {
    _state = newState;
    notifyListeners();
  }

  UserModel _createUserModel(
    Map<String, dynamic> userData,
  ) {
    return UserModel(
        id: userData["ID"],
        login: userData["LOGIN"],
        name: userData["NAME"],
        password: userData["PASSWORD"],
        status: userData["STATUS"]);
  }
}
