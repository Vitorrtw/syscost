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

  // Window
  windowManager.waitUntilReadyToShow(
    const WindowOptions(
      size: Size(600, 400),
      title: "Login",
      skipTaskbar: false,
    ),
    () async {
      await windowManager.show();
      await windowManager.setMaximizable(false);
      await windowManager.center();
    },
  );

  runApp(const MyApp());
}
