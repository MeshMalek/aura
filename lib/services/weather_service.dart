import 'package:aura/models/weather_model.dart';
import 'package:aura/services/erorr_handler.dart';
import 'package:dio/dio.dart';

//creating Weather Service
class WeatherService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  WeatherService({required this.apiKey});
  //getting weather data from the api
  Future<Weather> getWeather(String cityName) async {
    // final response
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'},
      );
      // checking the server recive request or not
      if (response.statusCode == 200) {
        return Weather.fromJson(response.data);
        // Success
      } else {
        // Handle non-200 status codes
        HttpErrorHandler.handleStatusCode(response.statusCode);
    }
    } on DioException catch (e) {
      HttpErrorHandler.handleDioException(e);
    }
    throw Exception('Failed to fetch weather data');
  }
}
