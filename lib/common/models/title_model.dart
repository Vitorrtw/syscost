// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/models/user_model.dart';

enum TitleStatus {
  active("Ativo", 1),
  inactive("Inativo", 2),
  paid("Quitado", 3);

  final String description;
  final int code;

  const TitleStatus(this.description, this.code);
}

class TitleModel {
  final String? id;
  final String? name;
  final String? description;
  final PersonModel? person;
  final int? status;
  final double? discount;
  final double? fees;
  final double? value;
  final UserModel? userCreate;
  final PersonModel? userAcquittance;
  final String? dateCreated;
  final String? dateAcquittance;

  TitleModel({
    this.id,
    this.name,
    this.description,
    this.person,
    this.status,
    this.discount,
    this.fees,
    this.value,
    this.userCreate,
    this.userAcquittance,
    this.dateCreated,
    this.dateAcquittance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'person': person?.toMap(),
      'status': status,
      'discount': discount,
      'fees': fees,
      'value': value,
      'userCreate': userCreate?.toMap(),
      'userAcquittance': userAcquittance?.toMap(),
      'dateCreated': dateCreated,
      'dateAcquittance': dateAcquittance,
    };
  }

  factory TitleModel.fromMap(Map<String, dynamic> map) {
    return TitleModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      person: map['person'] != null
          ? PersonModel.fromMap(map['person'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as int : null,
      discount: map['discount'] != null ? map['discount'] as double : null,
      fees: map['fees'] != null ? map['fees'] as double : null,
      value: map['value'] != null ? map['value'] as double : null,
      userCreate: map['userCreate'] != null
          ? UserModel.fromMap(map['userCreate'] as Map<String, dynamic>)
          : null,
      userAcquittance: map['userAcquittance'] != null
          ? PersonModel.fromMap(map['userAcquittance'] as Map<String, dynamic>)
          : null,
      dateCreated:
          map['dateCreated'] != null ? map['dateCreated'] as String : null,
      dateAcquittance: map['dateAcquittance'] != null
          ? map['dateAcquittance'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TitleModel.fromJson(String source) =>
      TitleModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
