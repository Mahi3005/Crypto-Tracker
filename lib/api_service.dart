import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';

  // Fetch cryptocurrency data from CoinGecko
  Future<List<Map<String, String>>> getCryptocurrencies() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/coins/markets?vs_currency=usd'));

      if (response.statusCode == 200) {
        // Print response to verify data
        print(response.body);

        List<dynamic> data = json.decode(response.body);
        return data.map((crypto) {
          // Safely accessing fields and ensuring values are String
          return {
            'name': crypto['name']?.toString() ?? 'Unknown', // Convert to String
            'price': '\$${crypto['current_price']?.toString() ?? '0'}', // Convert to String
            'change': '${crypto['price_change_percentage_24h']?.toString() ?? '0'}%', // Convert to String
          };
        }).toList();
      } else {
        throw Exception('Failed to load cryptocurrency data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors and log them
      print('Error fetching data: $e');
      throw Exception('Failed to fetch cryptocurrency data');
    }
  }

  // Fetch details about a single cryptocurrency
  Future<Map<String, String>> getCryptoDetails(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/coins/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'name': data['name']?.toString() ?? 'Unknown',
        'price': '\$${data['market_data']['current_price']['usd']?.toString() ?? '0'}',
        'market_cap': '\$${data['market_data']['market_cap']['usd']?.toString() ?? '0'}',
        'volume': '\$${data['market_data']['total_volume']['usd']?.toString() ?? '0'}',
        'image': data['image']['large']?.toString() ?? '',
      };
    } else {
      throw Exception('Failed to load cryptocurrency details');
    }
  }
}
