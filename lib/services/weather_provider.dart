import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WeatherProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get history => _history;

  WeatherProvider() {
    _loadHistory();
  }

  void addToHistory(Map<String, dynamic> cityData) {
    _history.insert(0, cityData);
    _saveHistory();
    notifyListeners();
  }

  void removeFromHistory(int index) {
    _history.removeAt(index);
    _saveHistory();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = jsonEncode(_history);
    await prefs.setString('weather_history', historyJson);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('weather_history');
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      _history.addAll(decoded.cast<Map<String, dynamic>>());
      notifyListeners();
    }
  }
}