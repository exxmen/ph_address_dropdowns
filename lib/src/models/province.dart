import 'package:equatable/equatable.dart';

class Province extends Equatable {
  final String psgcCode;
  final String regCode;
  final String provCode;
  final String provName;

  const Province({
    required this.psgcCode,
    required this.regCode,
    required this.provCode,
    required this.provName,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      psgcCode: json['psgcCode'] as String,
      regCode: json['regCode'] as String,
      provCode: json['provCode'] as String,
      provName: json['provName'] as String,
    );
  }

  @override
  List<Object?> get props => [psgcCode, regCode, provCode, provName];
}
