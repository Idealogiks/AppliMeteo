import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 166, 186, 222)),
      ),
      home: const MyHomePage(title: 'Météo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  String? _cityName;
  String? _weatherCondition;
  double? _temperature;
  double? _uv; 
  String? _errorMessage;

  Future<void> fetchWeather(String city) async {
    final url = Uri.parse('http://api.weatherapi.com/v1/current.json?key=fc8af4f182584f959db130334251004&q=$city');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _cityName = data['location']['name'];
          _weatherCondition = data['current']['condition']['text'];
          _temperature = data['current']['temp_c'];
          _uv = data['current']['uv'];
          _errorMessage = null; 
        });
      } else {
        setState(() {
          _errorMessage = 'Ville introuvable ou erreur de requête.';
          _cityName = null;
          _weatherCondition = null;
          _temperature = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la récupération des données : $e';
        _cityName = null;
        _weatherCondition = null;
        _uv = null;
        _temperature = null;
      });
    }
  }

  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.help;
    if (condition.toLowerCase().contains('sun')) return Icons.wb_sunny;
    if (condition.toLowerCase().contains('cloud')) return Icons.cloud;
    if (condition.toLowerCase().contains('rain')) return Icons.umbrella;
    if (condition.toLowerCase().contains('snow')) return Icons.ac_unit;
    if (condition.toLowerCase().contains('storm')) return Icons.flash_on;
    if (condition.toLowerCase().contains('fog')) return Icons.foggy;
    if (condition.toLowerCase().contains('wind')) return Icons.air;
    if (condition.toLowerCase().contains('mist')) return Icons.filter_drama; 
    if (condition.toLowerCase().contains('overcast')) return Icons.cloud_queue;  
    if (condition.toLowerCase().contains('clear')) return Icons.wb_sunny;  
    return Icons.help;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Entrez une ville',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                fetchWeather(value);
              },
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (_cityName != null && _weatherCondition != null && _temperature != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 166, 186, 222),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getWeatherIcon(_weatherCondition),
                      size: 50,
                      color: Colors.grey,
                    ),
                    Text(
                      'Ville : $_cityName',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Température : ${_temperature!.toStringAsFixed(1)}°C',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Condition : $_weatherCondition',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'UV :  ${_uv!.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}