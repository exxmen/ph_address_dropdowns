import 'package:equatable/equatable.dart';

class Region extends Equatable {
  final String psgcCode;
  final String regCode;
  final String regionName;

  const Region({
    required this.psgcCode,
    required this.regCode,
    required this.regionName,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      psgcCode: json['psgcCode'] as String,
      regCode: json['regCode'] as String,
      regionName: json['regionName'] as String,
    );
  }

  @override
  List<Object?> get props => [psgcCode, regCode, regionName];
}
