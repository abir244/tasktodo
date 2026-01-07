
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationApi {
  /// Returns a readable address for the given coordinates, or null.
  Future<String?> reverseGeocode(LatLng latLng) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final components = [
        p.name,
        p.subLocality,
        p.locality,
        p.administrativeArea,
        p.postalCode,
        p.country,
      ].where((e) => (e != null && e!.trim().isNotEmpty)).map((e) => e!.trim()).toList();

      return components.join(', ');
    } catch (_) {
      return null;
    }
  }
}
