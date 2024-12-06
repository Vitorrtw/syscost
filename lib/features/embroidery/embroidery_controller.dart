import 'package:flutter/material.dart';
import 'package:syscost/features/embroidery/embroidery_state.dart';
import 'package:syscost/services/data_services.dart';
import 'package:syscost/services/secure_storage.dart';

class EmbroideryController extends ChangeNotifier {
  final DataServices _dataServices;
  final SecuredStorage _securedStorage;

  EmbroideryController({
    required DataServices dataService,
    required SecuredStorage securedStorage,
  })  : _dataServices = dataService,
        _securedStorage = securedStorage;

  EmbroideryState _state = EmbroideryStateInitial();

  EmbroideryState get state => _state;

  void _changeState(EmbroideryState newState) {
    _state = newState;
    notifyListeners();
  }
}
