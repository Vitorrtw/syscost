// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:syscost/common/models/cut_model.dart';
import 'package:syscost/common/models/person_model.dart';
import 'package:syscost/common/models/user_model.dart';
import 'package:syscost/common/utils/datetime_adapter.dart';

enum TitleStatus {
  active("Aberto", 1),
  inactive("Inativo", 2),
  paid("Quitado", 3);

  final String description;
  final int code;

  const TitleStatus(this.description, this.code);
}

enum TitleType {
  ownership("R", 1),
  obligation("O", 0);

  final String description;
  final int code;

  const TitleType(this.description, this.code);
}

class TitleModel {
  final int? id;
  final String? name;
  final String? description;
  final int? person;
  final TitleStatus? status;
  final TitleType? type;
  int? qrp;
  final double? discount;
  final double? fees;
  final double? value;
  final double? faceValue;
  int? userCreate;
  final int? userAcquittance;
  final String? createdAt;
  final String? dueDate;
  final String? dateAcquittance;

  TitleModel({
    this.person,
    this.userCreate,
    this.userAcquittance,
    this.id,
    this.name,
    this.description,
    this.status,
    this.type,
    this.qrp,
    this.discount,
    this.fees,
    this.value,
    this.faceValue,
    this.createdAt,
    this.dueDate,
    this.dateAcquittance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'person': person,
      'status': status?.code,
      'type': type?.code,
      'qrp': qrp,
      'discount': discount,
      'fees': fees,
      'value': value,
      'faceValue': faceValue,
      'userCreate': userCreate,
      'userAcquittance': userAcquittance,
      'createdAt': createdAt,
      'dueDate': dueDate,
      'dateAcquittance': dateAcquittance,
    };
  }

  factory TitleModel.fromMap(Map<String, dynamic> map) {
    return TitleModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      person: map['person'] != null ? map['person'] as int : null,
      status: map['status'] != null
          ? TitleStatus.values.firstWhere((e) => e.code == map['status'])
          : null,
      type: map['type'] != null
          ? TitleType.values.firstWhere((e) => e.code == map['type'])
          : null,
      qrp: map['qrp'] != null ? map['qrp'] as int : null,
      discount: map['discount'] != null ? map['discount'] as double : null,
      fees: map['fees'] != null ? map['fees'] as double : null,
      value: map['value'] != null ? map['value'] as double : null,
      userCreate: map['userCreate'] != null ? map['userCreate'] as int : null,
      userAcquittance:
          map['userAcquittance'] != null ? map['userAcquittance'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      dateAcquittance: map['dateAcquittance'] != null
          ? map['dateAcquittance'] as String
          : null,
      dueDate: map['dueDate'] != null ? map['dueDate'] as String : null,
      faceValue: map['faceValue'] != null ? map['faceValue'] as double : null,
    );
  }

  factory TitleModel.fromDb(Map<String, dynamic> map) {
    return TitleModel(
      id: map["ID"],
      name: map["NAME"],
      description: map["DESCRIPTION"],
      person: map["PERSON"],
      status: TitleStatus.values.firstWhere((e) => e.code == map["STATUS"]),
      type: TitleType.values.firstWhere((e) => e.code == map["TYPE"]),
      qrp: map["QRP"],
      discount: map["DISCOUNT"],
      fees: map["FEES"],
      value: map["VALUE"],
      userCreate: map["USERCREATE"],
      userAcquittance: map["USERACQUITTANCE"],
      createdAt: map["CREATEDAT"],
      dueDate: map["DUEDATE"],
      dateAcquittance: map["DATEACQUITTANCE"],
      faceValue: map["FACEVALUE"],
    );
  }

  String toJson() => json.encode(toMap());

  factory TitleModel.fromJson(String source) =>
      TitleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory TitleModel.createFromCut({
    required CutModel cut,
    required PersonModel person,
    required double titleValue,
    required UserModel usercreate,
  }) {
    return TitleModel(
      name: "Titulo Corte: ${cut.id}",
      description: "Titulo corte de numero: ${cut.id} - Nome: ${cut.name}",
      status: TitleStatus.active,
      person: person.id,
      userCreate: usercreate.id,
      qrp: cut.qrp,
      createdAt: DateTimeAdapter().getDateTimeNowBR(),
      type: TitleType.obligation,
      value: titleValue,
      faceValue: titleValue,
    );
  }
}
