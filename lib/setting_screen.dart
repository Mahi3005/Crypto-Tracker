import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedCurrency = 'USD'; // Default value
  String _selectedSortOption = 'Price'; // Default value
  String _selectedChangeDirection = 'Positive'; // Default direction for percentage change

  // List of options for currency and sorting preferences
  final List<String> _currencyOptions = ['USD', 'EUR', 'GBP', 'JPY'];
  final List<String> _sortOptions = ['Price', 'Name', 'Percentage Change'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Currency Selection
            const Text(
              'Select Currency:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                });
              },
              items: _currencyOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Sort By Selection
            const Text(
              'Sort By:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._sortOptions.map((sortOption) {
              return RadioListTile<String>(
                title: Text(sortOption),
                value: sortOption,
                groupValue: _selectedSortOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedSortOption = value!;
                  });
                },
              );
            }),

            const SizedBox(height: 20),

            // Percentage Change Direction Selection
            if (_selectedSortOption == 'Percentage Change') ...[
              const Text(
                'Sort by Percentage Change Direction:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RadioListTile<String>(
                title: const Text('Positive'),
                value: 'Positive',
                groupValue: _selectedChangeDirection,
                onChanged: (String? value) {
                  setState(() {
                    _selectedChangeDirection = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Negative'),
                value: 'Negative',
                groupValue: _selectedChangeDirection,
                onChanged: (String? value) {
                  setState(() {
                    _selectedChangeDirection = value!;
                  });
                },
              ),
            ],

            const SizedBox(height: 40),

            // Save Button
            ElevatedButton(
              onPressed: () {
                // Return the selected settings back to the HomePage
                Navigator.pop(context, {
                  'currency': _selectedCurrency,
                  'sort': _selectedSortOption,
                  'changeDirection': _selectedChangeDirection, // Passing direction as well
                });
              },
              child: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
