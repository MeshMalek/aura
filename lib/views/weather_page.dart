import 'package:aura/models/weather_model.dart';
import 'package:aura/services/weather_service.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(
    apiKey: 'ba0265bf7691d490f99256a8aa59ed98',
  );
  Weather? _weather;

  // fetch weather
  Future<void> _fetchWeather() async {
    // get weather for city
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
      // any erorrs
    } catch (e) {
      // show error message
    }
  }
  // weather animation

  // init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            // city name
            Text(
              _weather?.cityName ?? '',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            // temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            // weather condition
          ],
        ),
      ),
    );
  }
}
