import 'package:flutter_test/flutter_test.dart';
import 'package:ph_address_dropdowns/ph_address_dropdowns.dart';

// Mock rootBundle isn't easily possible in simple unit tests without Flutter binding.
// Instead we can test if we can import the classes and basic logic if we mock the data,
// but since we rely on actual assets, an integration test or widget test is better.
// For now, checks if classes compile and `fromJson` works with sample data.

void main() {
  group('PhLocationRepository Models', () {
    test('Region fromJson', () {
      final json = {
        "psgcCode": "1300000000",
        "regCode": "13",
        "regionName": "National Capital Region (NCR)",
      };
      final region = Region.fromJson(json);
      expect(region.regCode, '13');
      expect(region.regionName, 'National Capital Region (NCR)');
    });

    test('Province fromJson', () {
      final json = {
        "psgcCode": "1400100000",
        "regCode": "14",
        "provCode": "001",
        "provName": "Abra",
      };
      final province = Province.fromJson(json);
      expect(province.provName, 'Abra');
    });
  });
}
