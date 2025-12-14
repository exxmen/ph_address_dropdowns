# ph_address_dropdowns

A Flutter package providing reliable, government-sourced cascading address dropdowns for the Philippines (Region, Province, City/Municipality, Barangay).

## Features

*   **Official Data Source:** Uses the latest **PSGC (Philippine Standard Geographic Code)** data (currently updated to Q4 2024 / 2025-2Q).
*   **Cascading Logic:** Automatically filters Provinces based on Region, Cities based on Province, etc.
*   **Special Cases Handled:** deeply integrates logic for NCR (National Capital Region) which has no provinces, and other special administrative regions.
*   **Offline Ready:** All data is bundled locally in the package assets.
*   **Type Safe:** Provides Dart models (`Region`, `Province`, `CityMun`, `Barangay`).

## Usage

Import the package:

```dart
import 'package:ph_address_dropdowns/ph_address_dropdowns.dart';
```

Use the `PhAddressPicker` widget:

```dart
PhAddressPicker(
  onChanged: (address) {
    // Access selected values
    print('Region: ${address.region?.regionName}');
    print('Province: ${address.province?.provName}');
    print('City/Mun: ${address.cityMun?.munCityName}');
    print('Barangay: ${address.barangay?.brgyName}');
    
    // Get raw codes (PSGC)
    print('Barangay Code: ${address.barangay?.brgyCode}');
  },
)
```

## Data Updates

The data is sourced from the [`@jobuntux/psgc`](https://www.npmjs.com/package/@jobuntux/psgc) npm package which mirrors official PSA releases.

To update the data in this package to the latest version, verify the GitHub Action is running as scheduled.

This repository includes a scheduled GitHub Action (`.github/workflows/update_psgc.yml`) that:
1.  Runs weekly.
2.  Checks for a newer version of `@jobuntux/psgc` on npm.
3.  Automatically creates a Pull Request if new data (e.g., Q1 2025) is detected.

You can also trigger this workflow manually from the "Actions" tab in GitHub.

## License

MIT
