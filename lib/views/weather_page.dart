import 'package:aura/models/weather_model.dart';
import 'package:aura/services/weather_service.dart';
import 'package:aura/widgets/erorr_weather_widget.dart';
import 'package:aura/widgets/loading_weather_widget.dart';
import 'package:aura/widgets/weather_disblay_widget.dart';
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
  bool _isLoading = true;
  String? _errorMessage;

  // fetch weather - optimized to use coordinates directly
  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get position first (with timeout)
      final position = await _weatherService.getCurrentPosition();

      // Use coordinates directly (faster - skips geocoding step)
      final weather = await _weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('Error fetching weather: $e');
    }
  }

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isLoading)
              const LoadingWeatherWidget()
            else if (_errorMessage != null)
              ErrorWeatherWidget(
                errorMessage: _errorMessage!,
                onRetry: _fetchWeather,
              )
            else if (_weather != null)
              WeatherDisplayWidget(weather: _weather!),
          ],
        ),
      ),
    );
  }
}