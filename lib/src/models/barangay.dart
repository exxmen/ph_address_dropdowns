import 'package:equatable/equatable.dart';

class Barangay extends Equatable {
  final String psgcCode;
  final String regCode;
  final String provCode;
  final String munCityCode;
  final String brgyCode;
  final String brgyName;

  const Barangay({
    required this.psgcCode,
    required this.regCode,
    required this.provCode,
    required this.munCityCode,
    required this.brgyCode,
    required this.brgyName,
  });

  factory Barangay.fromJson(Map<String, dynamic> json) {
    return Barangay(
      psgcCode: json['psgcCode'] as String,
      regCode: json['regCode'] as String,
      provCode: json['provCode'] as String,
      munCityCode: json['munCityCode'] as String,
      brgyCode: json['brgyCode'] as String,
      brgyName: json['brgyName'] as String,
    );
  }

  @override
  List<Object?> get props => [
    psgcCode,
    regCode,
    provCode,
    munCityCode,
    brgyCode,
    brgyName,
  ];
}
