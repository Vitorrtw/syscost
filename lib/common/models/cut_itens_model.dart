// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CutItensModel {
  final String? color;
  final String? size;
  final int? quantity;

  CutItensModel({
    required this.color,
    required this.size,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'color': color,
      'size': size,
      'quantity': quantity,
    };
  }

  factory CutItensModel.fromMap(Map<String, dynamic> map) {
    return CutItensModel(
      color: map['color'] != null ? map['color'] as String : null,
      size: map['size'] != null ? map['size'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CutItensModel.fromJson(String source) =>
      CutItensModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
