import 'package:crypto_tracker/setting_screen.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, String>>> _cryptocurrencies;
  String _selectedCurrency = 'USD';
  String _selectedSortOption = 'Price';
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredCryptocurrencies = [];

  @override
  void initState() {
    super.initState();
    _cryptocurrencies = _apiService.getCryptocurrencies();
  }

  void _updateSettings(Map<String, String> settings) {
    setState(() {
      _selectedCurrency = settings['currency']!;
      _selectedSortOption = settings['sort']!;
    });
  }

  // Function to filter the cryptocurrencies based on search input
  // Function to filter the cryptocurrencies based on search input
void _filterCryptocurrencies(String query) {
  setState(() {
    _cryptocurrencies.then((cryptos) {
      _filteredCryptocurrencies = cryptos.where((crypto) {
        return crypto['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 160, 221, 251),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 160, 221, 251),
        elevation: 0,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Crypto Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 25),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () async {
                  // Navigate to the SettingsScreen and await the result
                  final settings = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );

                  // If settings are not null, update them
                  if (settings != null) {
                    _updateSettings(settings);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar for Cryptocurrencies
            TextField(
              controller: _searchController,
              onChanged: _filterCryptocurrencies,
              decoration: InputDecoration(
                labelText: 'Search Cryptocurrency',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // FutureBuilder to load and display the list of cryptocurrencies
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
                future: _cryptocurrencies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    // Sort the data based on the selected sorting option
                    List<Map<String, String>> sortedData = List.from(snapshot.data!);
                    if (_selectedSortOption == 'Price') {
                      sortedData.sort((a, b) => double.parse(a['price']!.replaceAll(',', '').replaceAll('\$', ''))
                          .compareTo(double.parse(b['price']!.replaceAll(',', '').replaceAll('\$', ''))));
                    } else if (_selectedSortOption == 'Name') {
                      sortedData.sort((a, b) => a['name']!.compareTo(b['name']!));
                    } else if (_selectedSortOption == 'Percentage Change') {
                      sortedData.sort((a, b) => double.parse(a['change']!.replaceAll('%', ''))
                          .compareTo(double.parse(b['change']!.replaceAll('%', ''))));
                    }

                    // Apply the search filter to the sorted data
                    List<Map<String, String>> displayedData = _searchController.text.isEmpty
                        ? sortedData
                        : _filteredCryptocurrencies.isEmpty ? sortedData : _filteredCryptocurrencies;

                    return ListView.builder(
                      itemCount: displayedData.length,
                      itemBuilder: (context, index) {
                        final crypto = displayedData[index];
                        final change = crypto['change']!;
                        final isPositiveChange = change.startsWith('+');

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              crypto['name']!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Price: $_selectedCurrency ${crypto['price']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              change,
                              style: TextStyle(
                                fontSize: 16,
                                color: isPositiveChange ? Colors.green : Colors.red,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    cryptocurrencyName: crypto['name']!,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
