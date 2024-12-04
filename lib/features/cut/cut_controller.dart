import 'package:flutter/material.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/models/cut_itens_model.dart';
import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/models/title_model.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/features/cut/cut_state.dart';
import 'package:syscost/services/data_services.dart';
import 'package:syscost/services/secure_storage.dart';

class CutController extends ChangeNotifier {
  final DataServices _dataServices;
  final SecuredStorage _securedStorage;
  static const String cutTable = "SYS_CUTS";
  static const String cutItensTable = "SYS_CUTS_ITENS";

  CutController({
    required DataServices dataService,
    required SecuredStorage securedStorage,
  })  : _dataServices = dataService,
        _securedStorage = securedStorage;

  CutState _state = CutStateInitial();

  CutState get state => _state;

  void _changeState(CutState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> createCut({
    required List<Map<String, dynamic>> cutItensData,
    required String cutName,
    required bool generateTitle,
    required PersonModel? person,
    required double? titleValue,
  }) async {
    final UserModel currentUser = await _getCurrentUser();
    final CutModel cutModel = CutModel(
      id: null,
      name: cutName,
      status: 0,
      completion: null,
      userCreate: currentUser.id,
      userFinished: null,
    );

    final response = await _dataServices.insertData(
        tableName: cutTable, data: cutModel.toMap());

    return response.fold(
      (error) {
        _changeState(CutStateError(error.message));
      },
      (data) async {
        cutModel.id = data;
        await _createCutItens(cutItens: cutItensData, cut: cutModel);
        await _createCutTitle(
            cut: cutModel,
            person: person!,
            titleValue: titleValue!,
            usercreate: currentUser);
      },
    );
  }

  Future<List?> getCuts() async {
    final cutDataList = await _dataServices.queryData(tableName: cutTable);

    return cutDataList.fold(
      (error) {
        _changeState(CutStateError(error.message));
        return null;
      },
      (data) {
        List cutList = data.map(_createCutModel).toList();
        return cutList;
      },
    );
  }

  Future<void> _createCutTitle(
      {required CutModel cut,
      required PersonModel person,
      required double titleValue,
      required UserModel usercreate}) async {
    final TitleModel title = TitleModel(
      name: "Titulo referente ao Corte: ${cut.id}",
      description:
          "Titulo Referente ao corte de numero: ${cut.id} - Nome: ${cut.name}",
      status: TitleStatus.active.code,
      person: person,
      userCreate: usercreate,
    );
  }

  Future<void> _createCutItens({
    required CutModel cut,
    required List<Map<String, dynamic>> cutItens,
  }) async {
    for (Map<String, dynamic> item in cutItens) {
      final color = item['color'];
      final sizes = item['sizes'] as Map<String, dynamic>;

      for (var entry in sizes.entries) {
        final cutModel = CutItensModel(
          cutId: cut.id,
          color: color,
          size: entry.key,
          quantity: int.tryParse(entry.value.toString()) ?? 0,
        );

        final response = await _dataServices.insertData(
          tableName: cutItensTable,
          data: cutModel.toMap(),
        );

        if (response.error != null) {
          _changeState(CutStateError(response.error!.message));
        }
      }
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

  Future<List<CutItensModel>?> _getCutItens({
    required int cutId,
  }) async {
    final DataResult response = await _dataServices.getWhere(
        tableName: cutItensTable, where: "CUTID = $cutId");

    return response.fold(
      (error) {
        _changeState(CutStateError(error.message));
        return null;
      },
      (data) {
        List<CutItensModel> cutItens = data.map(_createCutItensModel).toList();
        return cutItens;
      },
    );
  }

  CutModel _createCutModel(Map<String, dynamic> cutData) {
    return CutModel(
        id: cutData["ID"],
        completion: cutData["COMPLETION"],
        status: cutData["STATUS"],
        name: cutData["NAME"],
        userCreate: cutData["USECREATE"],
        userFinished: cutData["USERFINISHED"]);
  }

  CutItensModel _createCutItensModel(Map<String, dynamic> cutItensData) {
    return CutItensModel(
        cutId: cutItensData["CUTID"],
        color: cutItensData["COLOR"],
        size: cutItensData["SIZE"],
        quantity: cutItensData["QUANTITY"]);
  }
}
