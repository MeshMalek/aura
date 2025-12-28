import 'package:aura/models/weather_model.dart';
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
        switch (response.statusCode) {
          case 400:
            throw "Bad Request: Check the city name.";
          case 401:
            throw "Unauthorized: Check your API Key.";
          case 404:
            throw "City not found.";
          case 500:
            throw "Server is currently crashing.";
          default:
            throw "Oops! Something went wrong: ${response.statusCode}";
        }
      }
    } on DioException catch (e) {
      // Handle Dio errors (network issues, etc.)
      if (e.response != null) {
        switch (e.response?.statusCode) {
          case 400:
            throw "Bad Request: Check the city name.";
          case 401:
            throw "Unauthorized: Check your API Key.";
          case 404:
            throw "City not found.";
          case 500:
            throw "Server is currently crashing.";
          default:
            throw "Oops! Something went wrong: ${e.response?.statusCode}";
        }
      } else {
        // Something happened in setting up or sending the request
        throw "Check your internet connection!";
      }
    }
  }
}
