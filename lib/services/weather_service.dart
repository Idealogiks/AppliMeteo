import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse('http://api.weatherapi.com/v1/forecast.json?key=fc8af4f182584f959db130334251004&q=$city&days=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['location'] == null || data['current'] == null || data['forecast'] == null) {
        throw Exception('Données météo incomplètes.');
      }

      return {
        'cityName': data['location']['name'] ?? 'Ville inconnue',
        'countryName': data['location']['country'] ?? 'Pays inconnu',
        'weatherCondition': data['current']['condition']['text'] ?? 'Condition inconnue',
        'temperature': data['current']['temp_c'] ?? 0.0,
        'feelsLike': data['current']['feelslike_c'] ?? 0.0,
        'humidity': data['current']['humidity'] ?? 0.0,
        'pressure': data['current']['pressure_mb'] ?? 0.0,
        'windSpeed': data['current']['wind_kph'] ?? 0.0,
        'sunrise': data['forecast']['forecastday'][0]['astro']['sunrise'] ?? 'N/A',
        'sunset': data['forecast']['forecastday'][0]['astro']['sunset'] ?? 'N/A',
        'uv': data['current']['uv'] ?? 0.0,
        'iconUrl': 'http:${data['current']['condition']['icon']}',
      };
    } else {
      throw Exception('Ville introuvable ou erreur de requête.');
    }
  }
}