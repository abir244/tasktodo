
import 'package:geolocator/geolocator.dart';

class Permissions {
  /// Returns current permission status; requests if denied.
  static Future<LocationPermission> ensureLocationWhenInUse() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  static Future<bool> ensureLocationServicesEnabled() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      await Geolocator.openLocationSettings();
    }
    return enabled;
  }

  static bool isGranted(LocationPermission p) {
    return p == LocationPermission.whileInUse || p == LocationPermission.always;
  }
}
