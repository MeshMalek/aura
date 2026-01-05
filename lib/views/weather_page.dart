

import 'package:aura/models/weather_model.dart';
import 'package:aura/services/weather_service.dart';
import 'package:aura/widgets/loading_weather_widget.dart';
import 'package:aura/widgets/erorr_weather_widget.dart';
import 'package:aura/widgets/search_city_widget.dart';
import 'package:aura/widgets/weather_disblay_widget.dart';
import 'package:aura/models/weather_mode.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(
    apiKey: 'ba0265bf7691d490f99256a8aa59ed98',
  );
  Weather? weather;
  bool isLoading = true;
  String? errorMessage;
  WeatherMode mode = WeatherMode.location;
  String city = '';

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      Weather fetchedWeather; // Changed name to avoid shadowing

      if (mode == WeatherMode.location) {
        // Use current location
        final position = await _weatherService.getCurrentPosition();
        fetchedWeather = await _weatherService.getWeatherByCoordinates(
          position.latitude,
          position.longitude,
        );
      } else {
        // Use city name
        fetchedWeather = await _weatherService.getWeather(city);
      }

      setState(() {
        weather = fetchedWeather; // Fixed: use this.weather
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar at the top (always visible)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchCityWidget(
                city: city,
                onChanged: (value) {
                  city = value;
           
                },
                onSearch: () {
                  if (city.isNotEmpty) {
                    setState(() {
                      mode = WeatherMode.city;
                    });
                    fetchWeather();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            // Location button
            IconButton(
              onPressed: () {
                setState(() {
                  mode = WeatherMode.location;
                  city = ''; // Clear search when using location
                });
                fetchWeather();
              },
              icon: const Icon(Icons.my_location),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              tooltip: 'Use my location',
            ),
            // Weather content in the center
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const LoadingWeatherWidget()
                    else if (errorMessage != null)
                      ErrorWeatherWidget(
                        errorMessage: errorMessage!,
                        onRetry: fetchWeather,
                      )
                    else if (weather != null)
                      WeatherDisplayWidget(weather: weather!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
