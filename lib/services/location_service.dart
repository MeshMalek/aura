import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Check and request location permissions
  Future<LocationPermission> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permission denied. Please enable location services.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        'Location permission denied forever. Please enable it in app settings.',
      );
    }

    return permission;
  }

  /// Check if location services are enabled
  Future<void> _checkLocationServiceEnabled() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException(
        'Location services are disabled. Please enable location services.',
      );
    }
  }

  /// Get current position with timeout
  Future<Position> getCurrentPosition({
    Duration timeLimit = const Duration(seconds: 10),
  }) async {
    await _checkAndRequestPermission();
    await _checkLocationServiceEnabled();

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(timeLimit: timeLimit),
    );
  }
}

/// Custom exception for location-related errors
class LocationException implements Exception {
  final String message;
  LocationException(this.message);
  
  @override
  String toString() => message;
}