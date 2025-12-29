import 'package:aura/models/weather_model.dart';
import 'package:aura/services/erorr_handler.dart';
import 'package:aura/services/location_service.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const Duration _defaultTimeout = Duration(seconds: 10);
  static const String _units = 'metric';

  final Dio _dio;
  final String apiKey;
  final LocationService _locationService;

  WeatherService({
    required this.apiKey,
    Dio? dio,
    LocationService? locationService,
  }) : _dio = dio ?? Dio(),
       _locationService = locationService ?? LocationService() {
    // Configure Dio defaults
    _dio.options.baseUrl = _baseUrl;
    _dio.options.receiveTimeout = _defaultTimeout;
    _dio.options.sendTimeout = _defaultTimeout;
  }

  /// Get weather data by city name
  Future<Weather> getWeather(String cityName) async {
    return _fetchWeather(
      queryParameters: {'q': cityName, 'appid': apiKey, 'units': _units},
    );
  }

  /// Get weather data by coordinates
  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    return _fetchWeather(
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': _units,
      },
    );
  }
  /// Private method to handle the actual API call (eliminates duplication)
  Future<Weather> _fetchWeather({
    required Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return Weather.fromJson(response.data);
      } else {
        HttpErrorHandler.handleStatusCode(response.statusCode);
        throw WeatherException('Failed to fetch weather data');
      }
    } on DioException catch (e) {
      HttpErrorHandler.handleDioException(e);
      throw WeatherException('Failed to fetch weather data');
    }
  }

  /// Get current position (delegates to LocationService)
  Future<Position> getCurrentPosition() {
    return _locationService.getCurrentPosition();
  }

}
/// Custom exception for weather-related errors
class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => message;
}
