import 'package:flutter/material.dart';
import 'package:mon_app/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  String city;
  String countryName;
  String temp;
  String feelsLike;
  String humidity;
  String pressure;
  String windSpeed;
  String sunrise;
  String sunset;
  String uv;
  String weatherCondition;
  String? iconUrl;

  DetailsPage({
    super.key,
    required this.city,
    required this.countryName,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.uv,
    required this.weatherCondition,
    this.iconUrl,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isLoading = false;

  Future<void> _refreshWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await WeatherService.fetchWeather(widget.city);
      setState(() {
        widget.temp = data['temperature'].toStringAsFixed(1);
        widget.feelsLike = data['feelsLike'].toStringAsFixed(1);
        widget.humidity = data['humidity'].toStringAsFixed(1);
        widget.pressure = data['pressure'].toStringAsFixed(1);
        widget.windSpeed = data['windSpeed'].toStringAsFixed(1);
        widget.sunrise = data['sunrise'];
        widget.sunset = data['sunset'];
        widget.uv = data['uv'].toStringAsFixed(1);
        widget.weatherCondition = data['weatherCondition'];
        widget.iconUrl = data['iconUrl'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails pour ${widget.city}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF607D8B),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshWeather,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFB0BEC5), // Fond gris pour la page
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Fond clair pour le container
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.iconUrl != null)
                      Transform.scale(
                        scale: 1.3,
                        child: Image.network(
                          widget.iconUrl!,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      '${widget.city}, ${widget.countryName}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF37474F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.weatherCondition,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Index UV : ${widget.uv}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFB0BEC5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.thermostat, size: 28, color: Color(0xFFEF9A9A)),
                            const SizedBox(width: 8),
                            Text('${widget.temp}°C', style: const TextStyle(fontSize: 18, color: Color(0xFF37474F))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.water_drop, size: 28, color: Color(0xFF90CAF9)),
                            const SizedBox(width: 8),
                            Text('Humidité : ${widget.humidity}%', style: const TextStyle(fontSize: 18, color: Color(0xFF37474F))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.speed, size: 28, color: Color(0xFFA5D6A7)),
                            const SizedBox(width: 8),
                            Text('Pression : ${widget.pressure} hPa', style: const TextStyle(fontSize: 18, color: Color(0xFF37474F))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.air, size: 28, color: Color(0xFFFFCC80)),
                            const SizedBox(width: 8),
                            Text('Vent : ${widget.windSpeed} km/h', style: const TextStyle(fontSize: 18, color: Color(0xFF37474F))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wb_sunny, size: 28, color: Color(0xFFFFF59D)),
                            const SizedBox(width: 8),
                            Text('Lever : ${formatTimeToFrench(widget.sunrise)}', style: const TextStyle(fontSize: 18, color: Color(0xFF37474F))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.nights_stay, size: 28, color: Color(0xFFCE93D8)),
                            const SizedBox(width: 8),
                            Text('Coucher : ${formatTimeToFrench(widget.sunset)}', style: const TextStyle(fontSize: 18, color: Color(0xFF37474F))),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF607D8B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      child: const Text(
                        'Retour',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}