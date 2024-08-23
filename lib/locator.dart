import 'package:get_it/get_it.dart';
import 'package:syscost/features/login/login_controller.dart';
import 'package:syscost/services/secure_storage.dart';
import 'package:syscost/services/sqlite_data_services.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton(() => SqliteDataServices());

  locator.registerFactory(
    () => LoginController(
        dataService: locator.get<SqliteDataServices>(),
        securedStorage: const SecuredStorage()),
  );
}
