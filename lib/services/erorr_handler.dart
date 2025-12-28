// lib/services/http_error_handler.dart
import 'package:dio/dio.dart';

class HttpErrorHandler {
  /// Handles HTTP status codes and throws appropriate error messages
  static void handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        throw "Bad Request: Check the city name.";
      case 401:
        throw "Unauthorized: Check your API Key.";
      case 404:
        throw "City not found.";
      case 500:
        throw "Server is currently crashing.";
      default:
        throw "Oops! Something went wrong: $statusCode";
    }
  }

  /// Handles DioException and throws appropriate error messages
  static void handleDioException(DioException e) {
    if (e.response != null) {
      handleStatusCode(e.response?.statusCode);
    } else {
      // Something happened in setting up or sending the request
      throw "Check your internet connection!";
    }
  }

  /// Generic handler that can process both Response and DioException
  static void handleResponse(Response? response, {DioException? dioException}) {
    if (dioException != null) {
      handleDioException(dioException);
    } else if (response != null && response.statusCode != 200) {
      handleStatusCode(response.statusCode);
    }
  }
}