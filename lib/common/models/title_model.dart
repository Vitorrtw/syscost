// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum TitleStatus {
  active("Ativo", 1),
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
  final int? status;
  final int? type;
  final double? discount;
  final double? fees;
  final double? value;
  final int? userCreate;
  final int? userAcquittance;
  final String? dateCreated;
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
    this.discount,
    this.fees,
    this.value,
    this.dateCreated,
    this.dateAcquittance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'person': person,
      'status': status,
      'type': type,
      'discount': discount,
      'fees': fees,
      'value': value,
      'userCreate': userCreate,
      'userAcquittance': userAcquittance,
      'dateCreated': dateCreated,
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
      status: map['status'] != null ? map['status'] as int : null,
      type: map['type'] != null ? map['type'] as int : null,
      discount: map['discount'] != null ? map['discount'] as double : null,
      fees: map['fees'] != null ? map['fees'] as double : null,
      value: map['value'] != null ? map['value'] as double : null,
      userCreate: map['userCreate'] != null ? map['userCreate'] as int : null,
      userAcquittance:
          map['userAcquittance'] != null ? map['userAcquittance'] as int : null,
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
