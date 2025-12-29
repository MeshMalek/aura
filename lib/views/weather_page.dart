import 'package:aura/models/weather_model.dart';
import 'package:aura/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

  // weather animation
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
              _buildLoadingUI()
            else if (_errorMessage != null)
              _buildErrorUI()
            else if (_weather != null)
              _buildWeatherUI(),
          ],
        ),
      ),
    );
  }

  // Helper method for loading state
  Widget _buildLoadingUI() {
    return const Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading weather...'),
      ],
    );
  }

  // Helper method for error state
  Widget _buildErrorUI() {
    return Column(
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _errorMessage!,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _fetchWeather, child: const Text('Retry')),
      ],
    );
  }

  // Helper method for weather display
  Widget _buildWeatherUI() {
    return Column(
      children: [
        // city name
        Text(
          _weather!.cityName,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // animation
        Lottie.asset(
          _getWeatherAnimation(_weather!.mainCondition),
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 16),
        // temperature
        Text(
          '${_weather!.temperature.round()}°C',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // weather condition
        Text(_weather!.mainCondition, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
