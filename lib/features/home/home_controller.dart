import 'package:flutter/material.dart';
import 'package:syscost/services/secure_storage.dart';
import 'package:syscost/services/sqlite_data_services.dart';

class HomeController extends ChangeNotifier {
  final SqliteDataServices _dataServices;
  final SecuredStorage _securedStorage;

  HomeController({
    required SqliteDataServices dataService,
    required SecuredStorage secureStorage,
  })  : _securedStorage = secureStorage,
        _dataServices = dataService;
}
