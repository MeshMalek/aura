import 'package:aura/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherDisplayWidget extends StatelessWidget {
  final Weather weather;

  const WeatherDisplayWidget({
    super.key,
    required this.weather,
  });

  // weather animation helper method
  String _getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/lottie/sun.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/Weather-windy.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // city name
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // animation
        Lottie.asset(
          _getWeatherAnimation(weather.mainCondition),
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 16),
        // temperature
        Text(
          '${weather.temperature.round()}°C',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // weather condition
        Text(
          weather.mainCondition,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}