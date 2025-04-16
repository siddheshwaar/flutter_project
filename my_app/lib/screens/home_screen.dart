import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_services.dart';
import '../models/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  void _search() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await WeatherService().getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _error = 'City not found!';
        _weather = null;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_weather != null) ...[
              Text(
                _weather!.cityName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.network(_weather!.iconUrl),
              Text(
                '${_weather!.temperature.toStringAsFixed(1)} °C',
                style: const TextStyle(fontSize: 32),
              ),
              Text(_weather!.description),
            ]
          ],
        ),
      ),
    );
  }
}
