import 'package:get_it/get_it.dart';
import 'package:syscost/features/cut/cut_controller.dart';
import 'package:syscost/features/login/login_controller.dart';
import 'package:syscost/features/person/person_controller.dart';
import 'package:syscost/features/title/title_controller.dart';
import 'package:syscost/features/user/user_controller.dart';
import 'package:syscost/services/data_services.dart';
import 'package:syscost/services/secure_storage.dart';
import 'package:syscost/services/sqlite_data_services.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<DataServices>(() => SqliteDataServices());

  locator.registerFactory(
    () => LoginController(
        dataService: locator.get<DataServices>(),
        securedStorage: const SecuredStorage()),
  );

  locator.registerFactory(
    () => UserController(dataService: locator.get<DataServices>()),
  );

  locator.registerFactory(
    () => PersonController(dataService: locator.get<DataServices>()),
  );

  locator.registerFactory(
    () => CutController(
        dataService: locator.get<DataServices>(),
        securedStorage: const SecuredStorage()),
  );

  locator.registerFactory(
    () => TitleController(
        dataService: locator.get<DataServices>(),
        securedStorage: const SecuredStorage()),
  );
}
