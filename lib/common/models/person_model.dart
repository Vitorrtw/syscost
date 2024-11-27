// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PersonModel {
  final int? id;
  final String? name;
  final int? status;
  final String? tell;
  final String? address;
  final String? number;
  final String? district;
  final String? city;
  final String? cep;
  final String? uf;

  PersonModel({
    required this.id,
    required this.name,
    required this.status,
    required this.tell,
    required this.address,
    required this.number,
    required this.district,
    required this.city,
    required this.cep,
    required this.uf,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'tell': tell,
      'address': address,
      'number': number,
      'district': district,
      'city': city,
      'cep': cep,
      'uf': uf,
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      tell: map['tell'] != null ? map['tell'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      number: map['number'] != null ? map['number'] as String : null,
      district: map['district'] != null ? map['district'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      cep: map['cep'] != null ? map['cep'] as String : null,
      uf: map['uf'] != null ? map['uf'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonModel.fromJson(String source) =>
      PersonModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
