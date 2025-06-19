
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vvxplore/user/userui.dart';
import 'package:vvxplore/user/ws.dart';


class WeatherScreen extends StatefulWidget {
  final String? Latitude;
  final String? Longitude;

  const WeatherScreen({
    Key? key,
    this.Latitude,
    this.Longitude,

  }) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService =
  WeatherService('66d0f057cc48980eb13fae45cbe5f7c8'); // Replace with your actual API key
  Map<String, dynamic>? _weatherData;
  Position? _currentPosition;
  String location = 'Null, Press Button';
  Completer<void> _temperatureAlertCompleter = Completer<void>(); // Ensures one-time alert

  double? lat;
  double? lan;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    User? user = FirebaseAuth.instance.currentUser;



    String? latitudee = widget.Latitude;
    String? longitudee = widget.Longitude;

    print(latitudee);
    print(longitudee);

    lat = double.parse(latitudee!);
    lan = double.parse(longitudee!);

    _fetchWeather(); // Fetch weather data after getting latitude and longitude

  }

  Future<void> _fetchWeather() async {
    try {
      var weather = await _weatherService.getWeather(lat!, lan!);
      setState(() {
        _weatherData = weather;
      });
      _checkTemperatureForAlert(_weatherData!['main']['temp'] - 273.15);
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature <= 40) {
      return Colors.blue;
    } else if (temperature > 50 && temperature <= 60) {
      return Colors.green;
    } else if (temperature > 80 && temperature <= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Future<void> _checkTemperatureForAlert(double temperature) async {
    if (temperature <= 25 && !_temperatureAlertCompleter.isCompleted) {
      // Calculate water requirement based on temperature
      String waterAmount = '';
      if (temperature <= 30) {
        waterAmount = 'Temperature is very low, carry warm clothes, gloves, thermal wear, and blankets for safety.Temperature is very low, carry warm clothes, gloves, thermal wear, and blankets for safety.'; // Example amount
      } else if (temperature > 45 && temperature <= 50) {
        waterAmount = 'Chilly weather ahead, wear thermals, a jacket, and carry a raincoat for protection';
      } else if (temperature > 60 && temperature <= 55) {
        waterAmount = 'Cool weather, wear light layers and stay hydrated to ensure comfort and safety';
      }

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Low Temperature Alert'),
          content: Text(
            'The current temperature is ${temperature.toStringAsFixed(1)} °C.\n\n'
                'It is recommended to avoid your travel $waterAmount of anywhere.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert dialog
                _temperatureAlertCompleter.complete(); // Mark alert as shown
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    // Navigate to HomeScreen when back button is pressed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserInterface()), // Replace with your actual screen
    );
    return false; // Prevents the default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
          backgroundColor: Colors.blueAccent, // Change app bar background color
          elevation: 0, // Remove elevation
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.white], // Background gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: _weatherData != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Weather in ${_weatherData!['name']}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text style
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Temperature: ${(_weatherData!['main']['temp'] - 273.15).toStringAsFixed(1)} °C',
                  style: TextStyle(
                    fontSize: 25,
                    color: _getTemperatureColor(
                        _weatherData!['main']['temp'] - 273.15), // Dynamically set text color
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Description: ${_weatherData!['weather'][0]['description']}',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            )
                : CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white), // Loading indicator color
            ),
          ),
        ),
      ),
    );
  }
}


