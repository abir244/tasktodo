
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/location_service.dart';
import '../model/user_location.dart';
import 'location_api.dart';

class LocationRepository {
  final LocationService _locationService;
  final LocationApi _api;

  LocationRepository(this._locationService, this._api);

  Future<UserLocation> readCurrentLocation() async {
    final pos = await _locationService.getCurrentPosition();
    final address = await _api.reverseGeocode(LatLng(pos.latitude, pos.longitude));
    return UserLocation(lat: pos.latitude, lng: pos.longitude, address: address);
  }

  Stream<UserLocation> locationStream({int distanceFilter = 5}) {
    return _locationService.positionStream(distanceFilter: distanceFilter).asyncMap((pos) async {
      final address = await _api.reverseGeocode(LatLng(pos.latitude, pos.longitude));
      return UserLocation(lat: pos.latitude, lng: pos.longitude, address: address);
    });
  }

  Future<String?> reverseGeocode(LatLng latLng) => _api.reverseGeocode(latLng);
}

