import 'package:flutter/material.dart';
import 'package:mon_app/screens/details_page.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/services/weather_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _removeCity(BuildContext context, int index) {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    provider.removeFromHistory(index);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final history = provider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des recherches'),
        backgroundColor: const Color.fromARGB(255, 134, 191, 255),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'Aucune ville recherchée.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final city = history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(city['cityName']),
                    subtitle: Text(city['countryName'] ?? 'Pays inconnu'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeCity(context, index),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            city: city['cityName'],
                            countryName: city['countryName'] ?? 'Inconnu',
                            temp: city['temperature'].toStringAsFixed(1),
                            feelsLike: city['feelsLike'].toStringAsFixed(1),
                            humidity: city['humidity'].toStringAsFixed(1),
                            pressure: city['pressure'].toStringAsFixed(1),
                            windSpeed: city['windSpeed'].toStringAsFixed(1),
                            sunrise: city['sunrise'],
                            uv: city['uv'].toStringAsFixed(1),
                            sunset: city['sunset'],
                            weatherCondition: city['weatherCondition'],
                            iconUrl: city['iconUrl'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}