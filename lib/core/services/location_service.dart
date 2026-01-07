
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// High accuracy current position (single read)
  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  /// Continuous location updates
  Stream<Position> positionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 5, // meters
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }
}
