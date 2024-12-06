import 'package:flutter/material.dart';
import 'package:syscost/common/constants/tables_names.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/models/cut_itens_model.dart';
import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/models/title_model.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/common/utils/functions.dart';
import 'package:syscost/features/cut/cut_state.dart';
import 'package:syscost/services/data_services.dart';
import 'package:syscost/services/secure_storage.dart';

class CutController extends ChangeNotifier {
  final DataServices _dataServices;
  final SecuredStorage _securedStorage;

  CutController({
    required DataServices dataService,
    required SecuredStorage securedStorage,
  })  : _dataServices = dataService,
        _securedStorage = securedStorage;

  CutState _state = CutStateInitial();

  CutState get state => _state;

  Future<void> createCut({
    required List<Map<String, dynamic>> cutItensData,
    required String cutName,
    required bool generateTitle,
    required PersonModel? person,
    required double? titleValue,
  }) async {
    _changeState(CutStateLoading());
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
        tableName: TablesNames.cuts, data: cutModel.toMap());

    return response.fold(
      (error) {
        _changeState(CutStateError(error.message));
      },
      (data) async {
        cutModel.id = data;

        /// Create Cut itens
        await _createCutItens(cutItens: cutItensData, cut: cutModel);
        if (generateTitle) {
          final TitleModel title = _createTitleModel(
            cut: cutModel,
            person: person!,
            titleValue: titleValue!,
            usercreate: currentUser,
          );

          /// Create Title
          await _createCutTitle(title: title);
        } else {
          _changeState(CutStateSuccess("Corte Cadastrado com Sucesso!"));
        }
      },
    );
  }

  Future<List?> getCuts() async {
    final cutDataList =
        await _dataServices.queryData(tableName: TablesNames.cuts);

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

  Future<List?> getCutItens({
    required int cutId,
  }) async {
    final DataResult response = await _dataServices.getWhere(
        tableName: TablesNames.cutItens, where: "CUTID = $cutId");

    return response.fold(
      (error) {
        _changeState(CutStateError(error.message));
        return null;
      },
      (data) {
        List cutItens = data.map(_createCutItensModel).toList();
        return cutItens;
      },
    );
  }

  Future<void> _createCutTitle({required TitleModel title}) async {
    // Title Model

    final response = await _dataServices.insertData(
      tableName: TablesNames.titles,
      data: title.toMap(),
    );

    if (response.error != null) {
      _changeState(CutStateError(response.error!.message));
      return;
    }

    _changeState(CutStateSuccess("Corte Cadastrado com Sucesso!"));
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
          tableName: TablesNames.cutItens,
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

  TitleModel _createTitleModel({
    required CutModel cut,
    required PersonModel person,
    required double titleValue,
    required UserModel usercreate,
  }) {
    return TitleModel(
      name: "Titulo Corte: ${cut.id}",
      description: "Titulo corte de numero: ${cut.id} - Nome: ${cut.name}",
      status: TitleStatus.active.code,
      person: person.id,
      userCreate: usercreate.id,
      dateCreated: getDateTimeNow(),
      type: TitleType.obligation.code,
      value: titleValue,
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

  void _changeState(CutState newState) {
    _state = newState;
    notifyListeners();
  }
}
