// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CutItensModel {
  final int? cutId;
  final String? color;
  final String? size;
  final int? quantity;
  final int? startQuantity;

  CutItensModel({
    required this.cutId,
    required this.color,
    required this.size,
    required this.quantity,
    required this.startQuantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cutId': cutId,
      'color': color,
      'size': size,
      'quantity': quantity,
      'startQuantity': startQuantity,
    };
  }

  factory CutItensModel.fromMap(Map<String, dynamic> map) {
    return CutItensModel(
      cutId: map['cutId'] != null ? map['cutId'] as int : null,
      color: map['color'] != null ? map['color'] as String : null,
      size: map['size'] != null ? map['size'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      startQuantity:
          map['startQuantity'] != null ? map['startQuantity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CutItensModel.fromJson(String source) =>
      CutItensModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
