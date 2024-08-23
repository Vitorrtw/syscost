import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syscost/app.dart';
import 'package:syscost/locator.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  sqfliteFfiInit();
  setup();

  runApp(const MyApp());
}
