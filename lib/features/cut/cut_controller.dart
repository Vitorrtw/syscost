import 'package:flutter/material.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/models/cut_itens_model.dart';
import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/features/cut/cut_state.dart';
import 'package:syscost/services/data_services.dart';

class CutController extends ChangeNotifier {
  final DataServices _dataServices;
  static const String CutTable = "SYS_CUTS";
  static const String CutItensTable = "SYS_CUST_ITENS";

  CutController({
    required DataServices dataService,
  }) : _dataServices = dataService;

  CutState _state = CutStateInitial();

  CutState get state => _state;

  void _changeState(CutState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<List?> getCuts() async {
    _changeState(CutStateLoading());
    final cutDataList = await _dataServices.queryData(tableName: CutTable);

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

  Future<List<CutItensModel>?> _getCutItens({
    required int cutId,
  }) async {
    final DataResult response = await _dataServices.getWhere(
        tableName: CutItensTable, where: "CUTID = $cutId");

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
        itens: null,
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
