import 'package:flutter/material.dart';
import 'package:syscost/common/constants/tables_names.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/models/cut_itens_model.dart';
import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/models/title_model.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/common/utils/datetime_adapter.dart';
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
    _changeState(CutStateLoading());
    final UserModel currentUser = await _getCurrentUser();

    // Get QRP
    final qrpResponse = await _dataServices.getSequence(sequence: Sequence.qrp);

    if (qrpResponse.error != null) {
      _changeState(CutStateError(qrpResponse.error!.message));
      return;
    }

    final cutModel = CutModel.createDefault(
      name: cutName,
      userCreate: currentUser.id!,
      qrp: qrpResponse.data,
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
          final TitleModel title = TitleModel.createFromCut(
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
        List cutList = data.map(CutModel.fromDb).toList();
        return cutList;
      },
    );
  }

  Future<List<Map<String, dynamic>>?> getCutItens({
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
        final List<Map<String, dynamic>> cutItensList =
            _createCutItensList(cutItensDataList: cutItens);
        return cutItensList;
      },
    );
  }

  Future<void> alterCut({
    required int cutId,
    required String cutName,
    required List<Map<String, dynamic>> cutItens,
    required int cutStatus,
    required int qrp,
    required String? completion,
    required int userCreate,
    required int? userFinished,
  }) async {
    _changeState(CutStateLoading());

    final CutModel cut = CutModel(
      id: cutId,
      name: cutName,
      status: cutStatus,
      completion: completion,
      qrp: qrp,
      userCreate: userCreate,
      userFinished: userFinished,
      createdAt: null,
    );

    // Alter Cut data
    final response = await _dataServices.updateData(
      tableName: TablesNames.cuts,
      data: cut.toMap(),
      where: "ID = $cutId",
    );

    if (response.error != null) {
      _changeState(CutStateError(response.error!.message));
      return;
    }

    /// Delete Cut itens to add new ones
    await _deleteCutItens(cutId: cutId);

    await _createCutItens(cut: cut, cutItens: cutItens);

    _changeState(CutStateSuccess("Corte Alterado com sucesso!"));
  }

  Future<void> closeCut({required CutModel cut}) async {
    _changeState(CutStateLoading());

    final UserModel user = await _getCurrentUser();

    // Set Cut Values
    cut.status = 1;
    cut.userFinished = user.id;
    cut.completion = DateTimeAdapter().getDateTimeNowBR();

    final response = await _dataServices.updateData(
      tableName: TablesNames.cuts,
      data: cut.toMap(),
      where: "ID = ${cut.id}",
    );

    if (response.error != null) {
      _changeState(CutStateError(response.error!.message));
      return;
    }
    _changeState(CutStateSuccess("Corte Fechado com sucesso!"));
  }

  Future<void> deleteCut({required CutModel cut}) async {
    _changeState(CutStateLoading());

    final DataResult response = await _dataServices.deleteWhere(
        tableName: TablesNames.cuts, where: "ID = ${cut.id}");

    if (response.error != null) {
      _changeState(CutStateError(response.error!.message));
      return;
    }

    final DataResult itensResponse = await _dataServices.deleteWhere(
        tableName: TablesNames.cutItens, where: "CUTID = ${cut.id}");

    itensResponse.fold(
      (error) => _changeState(CutStateError(error.message)),
      (_) => _changeState(CutStateSuccess("Corte Deletado com Sucesso!")),
    );
  }

  Future<void> _createCutTitle({required TitleModel title}) async {
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
      final sizes = Map<String, dynamic>.from(item['sizes']);

      for (var entry in sizes.entries) {
        final cutModel = CutItensModel(
          cutId: cut.id,
          color: color,
          size: entry.key,
          quantity: int.tryParse(entry.value.toString()) ?? 0,
          startQuantity: int.tryParse(entry.value.toString()) ?? 0,
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

  List<Map<String, dynamic>> _createCutItensList(
      {required List cutItensDataList}) {
    Map<String, Map<String, dynamic>> groupedByColor = {};

    for (CutItensModel cutItem in cutItensDataList) {
      String? color = cutItem.color;
      String? size = cutItem.size;
      int? quantity = cutItem.quantity;

      if (!groupedByColor.containsKey(color)) {
        groupedByColor[color!] = {
          "color": color,
          "sizes": {},
          "total": 0,
        };
      }

      groupedByColor[color]?["sizes"][size] = quantity;
      groupedByColor[color]?["total"] += quantity;
    }
    List<Map<String, dynamic>> result = groupedByColor.values.toList();
    return result;
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

  CutItensModel _createCutItensModel(Map<String, dynamic> cutItensData) {
    return CutItensModel(
        cutId: cutItensData["CUTID"],
        color: cutItensData["COLOR"],
        size: cutItensData["SIZE"],
        quantity: cutItensData["QUANTITY"],
        startQuantity: cutItensData["STARTQUANTITY"]);
  }

  Future<void> _deleteCutItens({required int cutId}) async {
    final response = await _dataServices.deleteWhere(
        tableName: TablesNames.cutItens, where: "CUTID = $cutId");

    if (response.error != null) {
      _changeState(CutStateError(response.error!.message));
    }
  }
}
