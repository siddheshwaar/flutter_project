import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String _apiKey = '555ca12809ac5b35f4316b51bb4a4eb3'; // Replace with your OpenWeatherMap API key

  Future<Weather> getWeather(String cityName) async {
    final url = Uri.parse(
  'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric'
);

    final response = await http.get(url);
    
    if (response.statusCode != 200) {
      throw Exception('Failed to load weather');
    }

    final jsonBody = json.decode(response.body);
    return Weather.fromJson(jsonBody);
  }
}
