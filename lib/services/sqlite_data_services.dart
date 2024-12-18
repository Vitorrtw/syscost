import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:syscost/common/constants/tables_names.dart';
import 'package:syscost/common/data/data_result.dart';
import 'package:syscost/common/data/exceptions.dart';
import 'package:syscost/services/data_services.dart';

class SqliteDataServices extends DataServices {
  static const String dbName = "sysCont.db";
  static const String sqlCreate =
      "CREATE TABLE SYS_USERS(ID INTEGER PRIMARY KEY, LOGIN TEXT NOT NULL UNIQUE, NAME TEXT NOT NULL, PASSWORD TEXT NOT NULL, STATUS BOOL NOT NULL);INSERT INTO SYS_USERS(LOGIN, NAME, PASSWORD, STATUS) VALUES ('master', 'admin', 'admin', TRUE); CREATE TABLE SYS_PERSONS ( ID INTEGER UNIQUE PRIMARY KEY, NAME TEXT NOT NULL, STATUS BOOL NOT NULL, TELL TEXT, ADDRESS TEXT NOT NULL, NUMBER TEXT NOT NULL, DISTRICT TEXT NOT NULL, CITY TEXT NOT NULL, CEP TEXT, UF TEXT NOT NULL)";

  static const int dbVersion = 1;

  Future<Database> _dataBaseConnect() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, dbName);

    ///  Connect
    try {
      return openDatabase(
        path,
        version: dbVersion,
        onCreate: (db, version) async {
          await db.execute(sqlCreate);
        },
      );
    } catch (e) {
      throw Exception("Erro to connect in DataBase");
    }
  }

  @override
  Future<DataResult> deleteWhere({
    required String tableName,
    required String where,
  }) async {
    try {
      final dataBase = await _dataBaseConnect();
      final int response = await dataBase.delete(tableName, where: where);

      return DataResult.success(response);
    } catch (e) {
      return DataResult.failure(GeneralTextException(
          textCode:
              "Error to delete data in table $tableName: Error code ${e.toString()}"));
    }
  }

  @override
  Future<DataResult> insertData({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    try {
      final dataBase = await _dataBaseConnect();
      final int response = await dataBase.insert(tableName, data);

      return DataResult.success(response);
    } catch (e) {
      return DataResult.failure(
        GeneralTextException(
            textCode:
                "Error to insert Data in $tableName: Error Code ${e.toString()}"),
      );
    }
  }

  @override
  Future<DataResult> updateData({
    required String tableName,
    required Map<String, dynamic> data,
    required String where,
  }) async {
    try {
      final dataBase = await _dataBaseConnect();
      final int response = await dataBase.update(tableName, data, where: where);

      return DataResult.success(response);
    } catch (e) {
      return DataResult.failure(GeneralTextException(
          textCode:
              "Error to update data in $tableName : Erro ${e.toString()}"));
    }
  }

  @override
  Future<DataResult> getWhere({
    required String tableName,
    required String where,
    int limit = 50,
  }) async {
    try {
      final dataBase = await _dataBaseConnect();

      final List<Map<String, Object?>> response =
          await dataBase.query(tableName, where: where, limit: 50);
      if (response.isEmpty) {
        return DataResult.failure(
            const GeneralTextException(textCode: "No data to return"));
      }

      return DataResult.success(response);
    } catch (e) {
      return DataResult.failure(GeneralTextException(
          textCode:
              "Error to get data in table $tableName where $where : Error ${e.toString()}"));
    }
  }

  @override
  Future<DataResult> queryData({
    required String tableName,
  }) async {
    try {
      final dataBase = await _dataBaseConnect();

      final response = await dataBase.query(tableName);
      if (response.isEmpty) {
        return DataResult.failure(
            const GeneralTextException(textCode: "No data to return"));
      }
      return DataResult.success(response);
    } catch (e) {
      return DataResult.failure(GeneralTextException(
          textCode:
              "Error to get data from $tableName : Error: ${e.toString()}"));
    }
  }

  @override
  Future<DataResult> getSequence({required Sequence sequence}) async {
    try {
      final dataBase = await _dataBaseConnect();

      final response = await dataBase.query(TablesNames.sequence,
          where: "NAME = '${sequence.name}'");

      final Map<String, dynamic> qrpData = response.first;

      final int qrp = qrpData["VALUE"] + 1; // Add new value

      await dataBase.update(TablesNames.sequence, {"VALUE": qrp},
          where: "NAME = 'qrp'"); // set the new value

      return DataResult.success(qrp);
    } catch (e) {
      return DataResult.failure(GeneralTextException(
          textCode: "Error to get sequence : Error: ${e.toString()}"));
    }
  }
}
