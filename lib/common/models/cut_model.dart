// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:syscost/common/models/cut_itens_model.dart';

class CutModel {
  final int? id;
  final String? name;
  final int? status;
  final DateTime? completion;
  final int? userCreate;
  final int? userFinished;
  final List<CutItensModel> itens;

  CutModel({
    required this.id,
    required this.name,
    required this.status,
    required this.completion,
    required this.userCreate,
    required this.userFinished,
    required this.itens,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'completion': completion?.millisecondsSinceEpoch,
      'userCreate': userCreate,
      'userFinished': userFinished,
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory CutModel.fromMap(Map<String, dynamic> map) {
    return CutModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      completion: map['completion'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completion'] as int)
          : null,
      userCreate: map['userCreate'] != null ? map['userCreate'] as int : null,
      userFinished:
          map['userFinished'] != null ? map['userFinished'] as int : null,
      itens: List<CutItensModel>.from(
        (map['itens'] as List<int>).map<CutItensModel>(
          (x) => CutItensModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CutModel.fromJson(String source) =>
      CutModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
