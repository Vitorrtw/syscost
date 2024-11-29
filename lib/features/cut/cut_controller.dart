import 'package:flutter/material.dart';
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
}
