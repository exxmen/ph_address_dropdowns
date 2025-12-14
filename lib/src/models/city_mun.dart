import 'package:equatable/equatable.dart';

class CityMun extends Equatable {
  final String psgcCode;
  final String regCode;
  final String provCode;
  final String munCityCode;
  final String munCityName;

  const CityMun({
    required this.psgcCode,
    required this.regCode,
    required this.provCode,
    required this.munCityCode,
    required this.munCityName,
  });

  factory CityMun.fromJson(Map<String, dynamic> json) {
    return CityMun(
      psgcCode: json['psgcCode'] as String,
      regCode: json['regCode'] as String,
      provCode: json['provCode'] as String,
      munCityCode: json['munCityCode'] as String,
      munCityName: json['munCityName'] as String,
    );
  }

  @override
  List<Object?> get props => [
    psgcCode,
    regCode,
    provCode,
    munCityCode,
    munCityName,
  ];
}
