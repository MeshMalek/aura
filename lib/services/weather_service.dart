import 'package:aura/models/weather_model.dart';
import 'package:aura/services/erorr_handler.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
        queryParameters: {
          'q': cityName,
          'appid': 'ba0265bf7691d490f99256a8aa59ed98',
          'units': 'metric',
        },
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

  // get permission from user
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // fetch the cureent location
    Position position = await Geolocator.getCurrentPosition();

    //convert the location into a list of placemarks
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    //extract the city name from the frist placemark
    String? city = placemarks[0].locality;
    return city ?? '';
  }
}
