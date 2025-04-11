import 'package:flutter/material.dart';
import 'package:mon_app/screens/details_page.dart';
import 'package:mon_app/services/weather_service.dart';
import 'package:mon_app/widgets/weather_card.dart';
import 'package:provider/provider.dart';
import 'package:mon_app/services/weather_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _cityName;
  String? _countryName;
  double? _temperature;
  double? _feelsLike;
  double? _humidity;
  double? _pressure;
  double? _windSpeed;
  String? _sunrise;
  String? _sunset;
  double? _uv;
  String? _weatherCondition;
  String? _iconUrl;

  Future<void> fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await WeatherService.fetchWeather(city);
      setState(() {
        _cityName = data['cityName'];
        _countryName = data['countryName'];
        _temperature = (data['temperature'] as num).toDouble();
        _feelsLike = (data['feelsLike'] as num).toDouble();
        _humidity = (data['humidity'] as num).toDouble();
        _pressure = (data['pressure'] as num).toDouble();
        _windSpeed = (data['windSpeed'] as num).toDouble();
        _sunrise = data['sunrise'];
        _sunset = data['sunset'];
        _uv = (data['uv'] as num).toDouble();
        _weatherCondition = data['weatherCondition'];
        _iconUrl = data['iconUrl'];

        final provider = Provider.of<WeatherProvider>(context, listen: false);
        provider.addToHistory({
          'cityName': _cityName,
          'countryName': _countryName,
          'temperature': _temperature,
          'feelsLike': _feelsLike,
          'humidity': _humidity,
          'pressure': _pressure,
          'windSpeed': _windSpeed,
          'sunrise': _sunrise,
          'sunset': _sunset,
          'weatherCondition': _weatherCondition,
          'iconUrl': _iconUrl,
        });

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur : ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF90A4AE),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Rechercher une ville',
                labelStyle: const TextStyle(color: Color(0xFF607D8B), fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFB0BEC5), width: 2.0), 
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFB0BEC5), width: 2.5), 
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_cityController.text.isNotEmpty) {
                  fetchWeather(_cityController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF90A4AE),
                foregroundColor: Colors.white,
              ),
              child: const Text('Rechercher'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 16),
                textAlign: TextAlign.center,
              ),
            if (_cityName != null && _weatherCondition != null && _temperature != null)
              WeatherCard(
                cityName: _cityName!,
                countryName: _countryName ?? 'Inconnu',
                temperature: _temperature!,
                weatherCondition: _weatherCondition!,
                uv: _uv!,
                feelsLike: _feelsLike!,
                humidity: _humidity!,
                pressure: _pressure!,
                windSpeed: _windSpeed!,
                sunrise: _sunrise!,
                sunset: _sunset!,
                iconUrl: _iconUrl,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        city: _cityName!,
                        countryName: _countryName ?? 'Inconnu',
                        temp: _temperature!.toStringAsFixed(1),
                        feelsLike: _feelsLike!.toStringAsFixed(1),
                        humidity: _humidity!.toStringAsFixed(1),
                        pressure: _pressure!.toStringAsFixed(1),
                        windSpeed: _windSpeed!.toStringAsFixed(1),
                        sunrise: _sunrise!,
                        sunset: _sunset!,
                        uv: _uv!.toStringAsFixed(1),
                        weatherCondition: _weatherCondition!,
                        iconUrl: _iconUrl,
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            const Text(
              'Historique des recherches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.history.length,
                itemBuilder: (context, index) {
                  final item = provider.history[index];

                  final double temperature = item['temperature'] ?? 0.0;
                  final double feelsLike = item['feelsLike'] ?? 0.0;
                  final double humidity = item['humidity'] ?? 0.0;
                  final double pressure = item['pressure'] ?? 0.0;
                  final double windSpeed = item['windSpeed'] ?? 0.0;
                  final String sunrise = item['sunrise'] ?? 'N/A';
                  final String sunset = item['sunset'] ?? 'N/A';
                  final double uv = item['uv'] ?? 0.0;
                  final String weatherCondition = item['weatherCondition'] ?? 'Condition inconnue';
                  final String iconUrl = item['iconUrl'] ?? '';

                  return ListTile(
                    leading: Image.network(iconUrl),
                    title: Text('${item['cityName']}, ${item['countryName']}'),
                    subtitle: Text(
                        '$temperature°C - $weatherCondition'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            provider.removeFromHistory(index);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            city: item['cityName'],
                            countryName: item['countryName'],
                            temp: temperature.toStringAsFixed(1),
                            feelsLike: feelsLike.toStringAsFixed(1),
                            humidity: humidity.toStringAsFixed(1),
                            pressure: pressure.toStringAsFixed(1),
                            windSpeed: windSpeed.toStringAsFixed(1),
                            sunrise: sunrise,
                            sunset: sunset,
                            uv: uv.toStringAsFixed(1),
                            weatherCondition: weatherCondition,
                            iconUrl: iconUrl,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}