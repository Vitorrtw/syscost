import 'package:syscost/common/data/data_result.dart';

abstract class DataServices {
  Future<DataResult> insertData({
    required String tableName,
    required Map<String, dynamic> data,
  });

  Future<DataResult> updateData({
    required String tableName,
    required Map<String, dynamic> data,
    required String where,
  });

  Future<DataResult> queryData({
    required String tableName,
  });

  Future<DataResult> getWhere({
    required String tableName,
    required String where,
  });
}
