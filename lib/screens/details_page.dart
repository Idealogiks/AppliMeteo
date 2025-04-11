import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final String city;
  final String countryName;
  final String temp;
  final String feelsLike;
  final String humidity;
  final String pressure;
  final String windSpeed;
  final String sunrise;
  final String sunset;
  final String uv;
  final String weatherCondition;
  final String? iconUrl;

  const DetailsPage({
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
  bool _isRefreshing = false;

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails pour ${widget.city}'),
        backgroundColor: const Color.fromARGB(255, 134, 191, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.iconUrl != null)
                  Image.network(
                    widget.iconUrl!,
                    width: 100,
                    height: 100,
                  ),
                const SizedBox(height: 16),
                Text(
                  widget.city,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.weatherCondition,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.thermostat, size: 30, color: Color.fromARGB(255, 250, 99, 88)),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.temp}°C',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Ressenti : ${widget.feelsLike}°C',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.water_drop, size: 30, color: Colors.blue),
                        const SizedBox(height: 4),
                        Text(
                          'Humidité : ${widget.humidity}%',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.speed, size: 30, color: Colors.green),
                        const SizedBox(height: 4),
                        Text(
                          'Pression : ${widget.pressure} hPa',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.air, size: 30, color: Colors.orange),
                        const SizedBox(height: 4),
                        Text(
                          'Vent : ${widget.windSpeed} km/h',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.wb_sunny, size: 30, color: Colors.yellow),
                        const SizedBox(height: 4),
                        Text(
                          'Lever : ${widget.sunrise}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.nights_stay, size: 30, color: Colors.indigo),
                        const SizedBox(height: 4),
                        Text(
                          'Coucher : ${widget.sunset}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Retour',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                if (_isRefreshing)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}