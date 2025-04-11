import 'package:flutter/material.dart';
import 'package:mon_app/screens/details_page.dart';
import 'package:mon_app/services/weather_service.dart';
import 'package:mon_app/widgets/weather_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  String? _cityName;
  String? _countryName;
  String? _weatherCondition;
  double? _temperature;
  double? _uv;
  String? _iconUrl;
  double? _feelsLike;
  double? _humidity;
  double? _pressure;
  double? _windSpeed;
  String? _sunrise;
  String? _sunset;
  String? _errorMessage;
  bool _isLoading = false;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
                labelText: 'Entrez une ville',
                labelStyle: const TextStyle(color: Color(0xFF7F8C8D)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
          ],
        ),
      ),
    );
  }
}