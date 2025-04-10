import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 175, 163, 208)),
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
  final List<Map<String, dynamic>> villes = [
    {'lieu': 'Lille', 'weather': 'nuageux', 'temp': 17},
    {'lieu': 'Paris', 'weather': 'ensoleillé', 'temp': 20},
    {'lieu': 'Lyon', 'weather': 'pluvieux', 'temp': 15},
    {'lieu': 'Marseille', 'weather': 'ensoleillé', 'temp': 25},
    {'lieu': 'Toulouse', 'weather': 'nuageux', 'temp': 22},
    {'lieu': 'Nice', 'weather': 'ensoleillé', 'temp': 28},
    {'lieu': 'Bordeaux', 'weather': 'pluvieux', 'temp': 18},
    {'lieu': 'Strasbourg', 'weather': 'nuageux', 'temp': 16},
    {'lieu': 'Nantes', 'weather': 'pluvieux', 'temp': 19},
  ];

  int currentIndex = 0;

  IconData _getWeatherIcon(String weather) {
    switch (weather) {
      case 'ensoleillé':
        return Icons.wb_sunny;
      case 'nuageux':
        return Icons.cloud;
      case 'pluvieux':
        return Icons.umbrella;
      default:
        return Icons.help;
    }
  }

  Color _getWeatherColor(String weather) {
    switch (weather) {
      case 'ensoleillé':
        return Colors.yellow; 
      case 'nuageux':
        return Colors.grey;
      case 'pluvieux':
        return Colors.blue;
      case 'neigeux':
        return Colors.white;
      case 'orageux':
        return Colors.purple;
      default:
        return Colors.black; 
    }
  }

  void _changeMeteo() {
    setState(() {
      currentIndex = (currentIndex + 1) % villes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentVille = villes[currentIndex];
    final lieu = currentVille['lieu'];
    final weather = currentVille['weather'];
    final temp = currentVille['temp'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 175, 163, 208),
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: BoxConstraints(
                maxWidth: 250,
                maxHeight: 110,
                minWidth: 250,
                minHeight: 110,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getWeatherIcon(weather),
                    size: 50,
                    color: _getWeatherColor(weather), 
                  ),
                  Text(
                    "$lieu : $temp°C",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              onPressed: _changeMeteo,
              child: Text('Changer de ville'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 175, 163, 208),
        ),
        child: Row(
    mainAxisAlignment: MainAxisAlignment.center, 
    children: [
      Text('© 2025 Mon Application'),
    ],
  ),
      )
    );
  }
}