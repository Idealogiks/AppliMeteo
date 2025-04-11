import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String cityName;
  final String? countryName;
  final double temperature;
  final String weatherCondition;
  final double uv;
  final double? feelsLike;
  final double? humidity; 
  final double? pressure;
  final double? windSpeed;
  final String? sunrise;
  final String? sunset;
  final String? iconUrl;
  final VoidCallback onTap;

  const WeatherCard({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.temperature,
    required this.weatherCondition,
    required this.uv,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.iconUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconUrl != null)
              Image.network(
                iconUrl!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 8),
            Text(
              'Ville : $cityName',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            Text(
              'Température : ${temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}