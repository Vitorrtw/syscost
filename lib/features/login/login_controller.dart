import 'package:flutter/material.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/features/login/login_state.dart';
import 'package:syscost/services/secure_storage.dart';
import 'package:syscost/services/sqlite_data_services.dart';

class LoginController extends ChangeNotifier {
  final SqliteDataServices _dataService;
  final SecuredStorage _securedStorage;

  LoginController({
    required SqliteDataServices dataService,
    required SecuredStorage securedStorage,
  })  : _dataService = dataService,
        _securedStorage = securedStorage;

  LoginState _state = LoginStateInitial();

  LoginState get state => _state;

  void _changeState(LoginState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> _storageCurrentUser({
    required UserModel user,
  }) async {
    _securedStorage.write(key: "CURRENT_USER", value: user.toJson());
  }

  UserModel _createUserModel(Map<String, Object?> userData) {
    return UserModel(
        id: int.parse(userData['ID'].toString()),
        login: userData['LOGIN'].toString(),
        name: userData["NAME"].toString(),
        password: userData["PASSWORD"].toString(),
        status: int.parse(userData["STATUS"].toString()));
  }

  Future<void> doLogin({
    required String userName,
    required String userPassword,
  }) async {
    _changeState(LoginStateLoading());
    final DataResult response = await _dataService.getWhere(
        tableName: "SYS_USERS",
        where:
            "LOGIN = '$userName' AND PASSWORD = '$userPassword' AND STATUS = 1");

    response.fold(
      (error) => _changeState(LoginStateFailure(
          error.message == "No data to return"
              ? "Usuario não encontrado!"
              : error.message)),
      (data) async {
        final Map<String, Object?> userData = (data as List).first;
        final UserModel user = _createUserModel(userData);
        await _storageCurrentUser(user: user);
        _changeState(LoginStateSuccess());
      },
    );
  }
}
