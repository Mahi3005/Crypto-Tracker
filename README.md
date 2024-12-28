

# Crypto Tracker

A Flutter application that helps you track cryptocurrency prices, view detailed information, and customize settings such as currency and sorting preferences.

## Features

- **Search Cryptocurrency**: Search for specific cryptocurrencies by name.
- **Sort Options**: Sort cryptocurrencies by price, name, or percentage change.
- **Currency Selection**: Choose the currency in which you want to view cryptocurrency prices (USD, EUR, etc.).
- **Settings Page**: Customize sort options, currency, and view percentage change in positive or negative direction.
- **Detailed View**: Tap on any cryptocurrency to view detailed information such as price, market cap, trading volume, and more.

## Screenshots

*Include some screenshots of the app here to demonstrate the user interface.*

## Getting Started

To get started with this project, you need to have [Flutter](https://flutter.dev/docs/get-started/install) installed on your system.

### Prerequisites

- **Flutter**: You must have Flutter SDK installed. You can follow the installation guide [here](https://flutter.dev/docs/get-started/install).
- **Dart**: Dart is the programming language used to develop Flutter apps. It is bundled with the Flutter SDK.

### Clone the repository

Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/crypto_tracker.git
cd crypto_tracker
```

### Install dependencies

Once the project is cloned, you need to install the necessary packages:

```bash
flutter pub get
```

### Run the app

To run the app on your device, use the following command:

```bash
flutter run
```

This will launch the app in the default emulator or connected device.

## Project Structure

Here’s an overview of the project structure:

```
lib/
├── main.dart            # Entry point of the app
├── home_page.dart       # Home page where the list of cryptocurrencies is displayed
├── settings_screen.dart # Settings page for customizing sort options and currency
├── api_service.dart     # Handles API calls to fetch cryptocurrency data
├── detail_screen.dart   # Shows detailed information about a selected cryptocurrency
```

## Dependencies

This project uses the following Flutter dependencies:

- `flutter`: SDK for building Flutter apps.
- `http`: For making network requests (you may use it for fetching cryptocurrency data from an API).
- `provider`: For state management.
  
You can find the full list of dependencies in `pubspec.yaml`.

## API Integration

The app integrates with a cryptocurrency API to fetch real-time data about the prices, percentage changes, and other details of cryptocurrencies. The `api_service.dart` handles the logic to interact with the API and retrieve the necessary information.

### API Example:

Here’s an example of how the data is fetched from the API:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Map<String, String>>> getCryptocurrencies() async {
    final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'));

    if (response.statusCode == 200) {
      List<Map<String, String>> cryptocurrencies = [];
      List<dynamic> data = jsonDecode(response.body);
      
      for (var item in data) {
        cryptocurrencies.add({
          'name': item['name'],
          'price': item['current_price'].toString(),
          'change': item['price_change_percentage_24h'].toString(),
        });
      }
      return cryptocurrencies;
    } else {
      throw Exception('Failed to load cryptocurrencies');
    }
  }
}
