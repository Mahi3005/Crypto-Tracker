import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailScreen extends StatelessWidget {
  final String cryptocurrencyName;
  final ApiService _apiService = ApiService();

  // Constructor to accept cryptocurrency name
  DetailScreen({super.key, required this.cryptocurrencyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details about $cryptocurrencyName'),
        backgroundColor: const Color.fromARGB(255, 160, 221, 251),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _apiService.getCryptoDetails(cryptocurrencyName.toLowerCase()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final crypto = snapshot.data!;

            // Price trend data with more points and realistic movement
            final List<FlSpot> priceData = [
              FlSpot(0, 34000),
              FlSpot(1, 35200),
              FlSpot(2, 34800),
              FlSpot(3, 36500),
              FlSpot(4, 35800),
              FlSpot(5, 37200),
              FlSpot(6, 36800),
              FlSpot(7, 38500),
              FlSpot(8, 37900),
              FlSpot(9, 39200),
              FlSpot(10, 38600),
              FlSpot(11, 40000),
            ];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          crypto['image']!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Current Price: ${crypto['price']}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 160, 221, 251),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Market Cap: ${crypto['market_cap']}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '24h Trading Volume: ${crypto['volume']}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 5,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.black, width: 1)
                            ),
                            minX: 0,
                            maxX: 11,
                            minY: 33000,
                            maxY: 41000,
                            lineBarsData: [
                              LineChartBarData(
                                spots: priceData,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 4,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withOpacity(0.2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 160, 221, 251),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Price Trend Graph',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}