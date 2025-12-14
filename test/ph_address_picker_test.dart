import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ph_address_dropdowns/ph_address_dropdowns.dart';

class FakePhLocationRepository implements PhLocationRepository {
  @override
  Future<List<Region>> getRegions() async {
    return const [
      Region(psgcCode: '0100000000', regCode: '01', regionName: 'Region I'),
      Region(psgcCode: '1300000000', regCode: '13', regionName: 'NCR'),
    ];
  }

  @override
  Future<List<Province>> getProvinces(String regCode) async {
    if (regCode == '01') {
      return const [
        Province(
          psgcCode: '0102900000',
          regCode: '01',
          provCode: '029',
          provName: 'IIocos Norte',
        ),
      ];
    }
    return [];
  }

  @override
  Future<List<CityMun>> getCityMuns({
    required String regCode,
    String? provCode,
  }) async {
    if (regCode == '13') {
      return const [
        CityMun(
          psgcCode: '1339000000',
          regCode: '13',
          provCode: '000',
          munCityCode: '39',
          munCityName: 'Manila',
        ),
      ];
    }
    if (provCode == '029') {
      return const [
        CityMun(
          psgcCode: '0129010000',
          regCode: '01',
          provCode: '029',
          munCityCode: '01',
          munCityName: 'Adams',
        ),
      ];
    }
    return [];
  }

  @override
  Future<List<Barangay>> getBarangays(String cityMunCode) async {
    if (cityMunCode == '39') {
      return const [
        Barangay(
          psgcCode: '1339000001',
          regCode: '13',
          provCode: '000',
          munCityCode: '39',
          brgyCode: '001',
          brgyName: 'Barangay 1',
        ),
      ];
    }
    if (cityMunCode == '01') {
      return const [
        Barangay(
          psgcCode: '0129010001',
          regCode: '01',
          provCode: '029',
          munCityCode: '01',
          brgyCode: '001',
          brgyName: 'Adams Poblacion',
        ),
      ];
    }
    return [];
  }
}

void main() {
  testWidgets('PhAddressPicker cascading test', (WidgetTester tester) async {
    final fakeRepo = FakePhLocationRepository();
    AddressValue? lastValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            // Ensure scrolling if needed
            child: PhAddressPicker(
              repository: fakeRepo,
              onChanged: (val) => lastValue = val,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Check Regions Loaded
    expect(find.text('Select Region'), findsOneWidget);

    // 2. Select Region I
    await tester.tap(find.text('Select Region'), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Tap the menu item
    await tester.tap(find.text('Region I').last);
    await tester.pumpAndSettle();

    expect(lastValue?.region?.regCode, '01');
    expect(lastValue?.province, isNull);

    // 3. Select Province
    await tester.tap(find.text('Select Province'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('IIocos Norte').last);
    await tester.pumpAndSettle();

    expect(lastValue?.province?.provCode, '029');

    // 4. Select City
    await tester.tap(
      find.text('Select City / Municipality'),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adams').last);
    await tester.pumpAndSettle();

    expect(lastValue?.cityMun?.munCityCode, '01');

    // 5. Select Barangay
    await tester.scrollUntilVisible(
      find.text('Select Barangay'),
      50,
    ); // Ensure visible
    await tester.tap(find.text('Select Barangay'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adams Poblacion').last);
    await tester.pumpAndSettle();

    expect(lastValue?.barangay?.brgyName, 'Adams Poblacion');
  });

  testWidgets('PhAddressPicker NCR test (no province)', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakePhLocationRepository();
    AddressValue? lastValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PhAddressPicker(
              repository: fakeRepo,
              onChanged: (val) => lastValue = val,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Select NCR
    await tester.tap(find.text('Select Region'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('NCR').last);
    await tester.pumpAndSettle();

    // Province dropdown should NOT appear
    expect(find.text('Select Province'), findsNothing);

    // City Dropdown should be available directly
    // Ensure visibility
    await tester.scrollUntilVisible(
      find.text('Select City / Municipality'),
      50,
    );

    await tester.tap(
      find.text('Select City / Municipality'),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manila').last);
    await tester.pumpAndSettle();

    expect(lastValue?.cityMun?.munCityName, 'Manila');
  });
}
