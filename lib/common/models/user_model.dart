// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int? id;
  final String? login;
  final String? name;
  final String? password;
  final int? status;

  UserModel({
    required this.id,
    required this.login,
    required this.name,
    required this.password,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'login': login,
      'name': name,
      'password': password,
      'status': status,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      login: map['login'] != null ? map['login'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
