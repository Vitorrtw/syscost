// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CutModel {
  int? id;
  final String? name;
  final int? status;
  final String? completion;
  final int? userCreate;
  final int? userFinished;

  CutModel({
    required this.id,
    required this.name,
    required this.status,
    required this.completion,
    required this.userCreate,
    required this.userFinished,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'completion': completion,
      'userCreate': userCreate,
      'userFinished': userFinished,
    };
  }

  factory CutModel.fromMap(Map<String, dynamic> map) {
    return CutModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      completion:
          map['completion'] != null ? map['completion'] as String : null,
      userCreate: map['userCreate'] != null ? map['userCreate'] as int : null,
      userFinished:
          map['userFinished'] != null ? map['userFinished'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CutModel.fromJson(String source) =>
      CutModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
