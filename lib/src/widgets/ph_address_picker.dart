import 'package:flutter/material.dart';
import '../../ph_address_dropdowns.dart';

class PhAddressPicker extends StatefulWidget {
  final ValueChanged<AddressValue> onChanged;
  final AddressValue? initialValue;

  final PhLocationRepository? repository;

  const PhAddressPicker({
    Key? key,
    required this.onChanged,
    this.initialValue,
    this.repository,
  }) : super(key: key);

  @override
  State<PhAddressPicker> createState() => _PhAddressPickerState();
}

class AddressValue {
  final Region? region;
  final Province? province;
  final CityMun? cityMun;
  final Barangay? barangay;

  const AddressValue({this.region, this.province, this.cityMun, this.barangay});

  @override
  String toString() {
    return '${barangay?.brgyName}, ${cityMun?.munCityName}, ${province?.provName}, ${region?.regionName}';
  }
}

class _PhAddressPickerState extends State<PhAddressPicker> {
  late final PhLocationRepository _repository;

  List<Region> _regions = [];
  List<Province> _provinces = [];
  List<CityMun> _cityMuns = [];
  List<Barangay> _barangays = [];

  Region? _selectedRegion;
  Province? _selectedProvince;
  CityMun? _selectedCityMun;
  Barangay? _selectedBarangay;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? PhLocationRepository();
    _loadRegions();
    if (widget.initialValue != null) {
      // Logic to pre-populate would go here, requiring finding the objects by ID
      // For now, we just load regions.
    }
  }

  Future<void> _loadRegions() async {
    final regions = await _repository.getRegions();
    setState(() {
      _regions = List.of(regions);
      _regions.sort((a, b) => a.regionName.compareTo(b.regionName));
      _isLoading = false;
    });
  }

  Future<void> _onRegionChanged(Region? region) async {
    if (region == _selectedRegion) return;
    setState(() {
      _selectedRegion = region;
      _selectedProvince = null;
      _selectedCityMun = null;
      _selectedBarangay = null;
      _provinces = [];
      _cityMuns = [];
      _barangays = [];
    });

    if (region != null) {
      if (region.regCode == '13') {
        // NCR: No provinces, load cities directly
        final cityMuns = await _repository.getCityMuns(regCode: region.regCode);
        setState(() {
          _cityMuns = List.of(cityMuns);
          _cityMuns.sort((a, b) => a.munCityName.compareTo(b.munCityName));
        });
      } else {
        final provinces = await _repository.getProvinces(region.regCode);
        setState(() {
          _provinces = List.of(provinces);
          _provinces.sort((a, b) => a.provName.compareTo(b.provName));
        });
      }
    }
    _notifyChanged();
  }

  Future<void> _onProvinceChanged(Province? province) async {
    if (province == _selectedProvince) return;
    setState(() {
      _selectedProvince = province;
      _selectedCityMun = null;
      _selectedBarangay = null;
      _cityMuns = [];
      _barangays = [];
    });

    if (province != null) {
      final cityMuns = await _repository.getCityMuns(
        regCode: province.regCode,
        provCode: province.provCode,
      );
      setState(() {
        _cityMuns = List.of(cityMuns);
        _cityMuns.sort((a, b) => a.munCityName.compareTo(b.munCityName));
      });
    }
    _notifyChanged();
  }

  Future<void> _onCityMunChanged(CityMun? cityMun) async {
    if (cityMun == _selectedCityMun) return;
    setState(() {
      _selectedCityMun = cityMun;
      _selectedBarangay = null;
      _barangays = [];
    });

    if (cityMun != null) {
      final barangays = await _repository.getBarangays(cityMun.munCityCode);
      setState(() {
        _barangays = List.of(barangays);
        _barangays.sort((a, b) => a.brgyName.compareTo(b.brgyName));
      });
    }
    _notifyChanged();
  }

  void _onBarangayChanged(Barangay? barangay) {
    if (barangay == _selectedBarangay) return;
    setState(() {
      _selectedBarangay = barangay;
    });
    _notifyChanged();
  }

  void _notifyChanged() {
    widget.onChanged(
      AddressValue(
        region: _selectedRegion,
        province: _selectedProvince,
        cityMun: _selectedCityMun,
        barangay: _selectedBarangay,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown<Region>(
          label: 'Region',
          value: _selectedRegion,
          items: _regions,
          itemLabel: (r) => r.regionName,
          onChanged: _onRegionChanged,
        ),
        const SizedBox(height: 16),
        if (_selectedRegion?.regCode != '13') ...[
          _buildDropdown<Province>(
            label: 'Province',
            value: _selectedProvince,
            items: _provinces,
            itemLabel: (p) => p.provName,
            onChanged: _onProvinceChanged,
            enabled: _selectedRegion != null,
          ),
          const SizedBox(height: 16),
        ],
        _buildDropdown<CityMun>(
          label: 'City / Municipality',
          value: _selectedCityMun,
          items: _cityMuns,
          itemLabel: (c) => c.munCityName,
          onChanged: _onCityMunChanged,
          enabled:
              (_selectedProvince != null || _selectedRegion?.regCode == '13'),
        ),
        const SizedBox(height: 16),
        _buildDropdown<Barangay>(
          label: 'Barangay',
          value: _selectedBarangay,
          items: _barangays,
          itemLabel: (b) => b.brgyName,
          onChanged: _onBarangayChanged,
          enabled: _selectedCityMun != null,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabel(item), overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      isExpanded: true,
      hint: Text('Select $label'),
      disabledHint: Text('Select $label'),
    );
  }
}
