
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey; // Replace with your OpenWeatherMap API key

  WeatherService(this.apiKey);

  Future<Map<String, dynamic>> getWeather(double latitude, double longitude) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }
}
