import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/barangay.dart';
import '../models/city_mun.dart';
import '../models/province.dart';
import '../models/region.dart';

class PhLocationRepository {
  List<Region>? _regions;
  List<Province>? _provinces;
  List<CityMun>? _cityMuns;
  List<Barangay>? _barangays;

  static const String _regionsPath =
      'packages/ph_address_dropdowns/assets/json/regions.json';
  static const String _provincesPath =
      'packages/ph_address_dropdowns/assets/json/provinces.json';
  static const String _muncitiesPath =
      'packages/ph_address_dropdowns/assets/json/muncities.json';
  static const String _barangaysPath =
      'packages/ph_address_dropdowns/assets/json/barangays.json';

  /// Loads all data from JSON assets.
  /// Call this when initialization or lazily.
  Future<void> _loadData() async {
    if (_regions != null &&
        _provinces != null &&
        _cityMuns != null &&
        _barangays != null)
      return;

    final String regionsString = await rootBundle.loadString(_regionsPath);
    final List<dynamic> regionsJson = jsonDecode(regionsString);
    _regions = regionsJson.map((json) => Region.fromJson(json)).toList();

    final String provincesString = await rootBundle.loadString(_provincesPath);
    final List<dynamic> provincesJson = jsonDecode(provincesString);
    _provinces = provincesJson.map((json) => Province.fromJson(json)).toList();

    final String muncitiesString = await rootBundle.loadString(_muncitiesPath);
    final List<dynamic> muncitiesJson = jsonDecode(muncitiesString);
    _cityMuns = muncitiesJson.map((json) => CityMun.fromJson(json)).toList();

    final String barangaysString = await rootBundle.loadString(_barangaysPath);
    final List<dynamic> barangaysJson = jsonDecode(barangaysString);
    _barangays = barangaysJson.map((json) => Barangay.fromJson(json)).toList();
  }

  Future<List<Region>> getRegions() async {
    await _loadData();
    return _regions ?? [];
  }

  Future<List<Province>> getProvinces(String regCode) async {
    await _loadData();
    return _provinces?.where((p) => p.regCode == regCode).toList() ?? [];
  }

  Future<List<CityMun>> getCityMuns({
    required String regCode,
    String? provCode,
  }) async {
    await _loadData();

    // NCR is special (13). It has NO provinces in typical address dropdowns usually, but the PSGC data
    // assigns districts appearing as 'province'-like or just directly cities under NCR.
    // In strict PSGC, NCR cities like Manila have regCode=13 and provCode=000 or specific districts.

    if (regCode == '13') {
      // Return all cities in NCR
      return _cityMuns?.where((cm) => cm.regCode == regCode).toList() ?? [];
    }

    if (provCode != null) {
      return _cityMuns?.where((cm) => cm.provCode == provCode).toList() ?? [];
    }

    return [];
  }

  Future<List<Barangay>> getBarangays(String cityMunCode) async {
    await _loadData();
    return _barangays?.where((b) => b.munCityCode == cityMunCode).toList() ??
        [];
  }
}
