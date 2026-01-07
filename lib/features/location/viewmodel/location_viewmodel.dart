
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../ data/location_api.dart';
import '../ data/location_repository.dart';
import '../../../core/services/location_service.dart';
import '../../../core/utils/permissions.dart';
import '../model/user_location.dart';

/// STATE
class LocationState {
  final bool isLoading;
  final bool serviceEnabled;
  final LocationPermission? permission;
  final LatLng? current;            // GPS reported
  final LatLng? selected;           // camera/marker chosen
  final String? address;            // from reverse geocode
  final String? error;

  const LocationState({
    this.isLoading = false,
    this.serviceEnabled = false,
    this.permission,
    this.current,
    this.selected,
    this.address,
    this.error,
  });

  LocationState copyWith({
    bool? isLoading,
    bool? serviceEnabled,
    LocationPermission? permission,
    LatLng? current,
    LatLng? selected,
    String? address,
    String? error,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permission: permission ?? this.permission,
      current: current ?? this.current,
      selected: selected ?? this.selected,
      address: address ?? this.address,
      error: error,
    );
  }
}

/// VIEWMODEL
class LocationViewModel extends StateNotifier<LocationState> {
  final LocationRepository _repo;
  StreamSubscription<UserLocation>? _sub;

  LocationViewModel(this._repo) : super(const LocationState());

  Future<void> init() async {
    state = state.copyWith(isLoading: true, error: null);

    final services = await Permissions.ensureLocationServicesEnabled();
    var permission = await Permissions.ensureLocationWhenInUse();

    if (!services) {
      state = state.copyWith(isLoading: false, serviceEnabled: false, error: 'Location services disabled.');
      return;
    }

    if (!Permissions.isGranted(permission)) {
      state = state.copyWith(isLoading: false, permission: permission, error: 'Location permission not granted.');
      return;
    }

    state = state.copyWith(serviceEnabled: true, permission: permission);

    // Read current once
    final current = await _repo.readCurrentLocation();
    final currentLatLng = LatLng(current.lat, current.lng);
    state = state.copyWith(
      isLoading: false,
      current: currentLatLng,
      selected: currentLatLng,
      address: current.address,
    );

    // Subscribe to live updates
    _sub?.cancel();
    _sub = _repo.locationStream(distanceFilter: 5).listen((loc) {
      state = state.copyWith(
        current: LatLng(loc.lat, loc.lng),
        // Keep selected unless user moves camera; don't overwrite selected here
      );
    });
  }

  /// When user drags/zooms map camera
  void onCameraMove(LatLng target) {
    state = state.copyWith(selected: target);
  }

  /// After camera stops — reverse geocode selected point
  Future<void> onCameraIdle() async {
    final sel = state.selected;
    if (sel == null) return;
    final addr = await _repo.reverseGeocode(sel);
    state = state.copyWith(address: addr);
  }

  /// Center selected on current GPS
  void centerOnCurrent() {
    final cur = state.current;
    if (cur != null) {
      state = state.copyWith(selected: cur);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// PROVIDERS
final locationApiProvider = Provider((ref) => LocationApi());
final locationServiceProvider = Provider((ref) => LocationService());
final locationRepositoryProvider = Provider((ref) {
  return LocationRepository(ref.read(locationServiceProvider), ref.read(locationApiProvider));
});

final locationViewModelProvider =
StateNotifierProvider<LocationViewModel, LocationState>((ref) {
  final repo = ref.read(locationRepositoryProvider);
  final vm = LocationViewModel(repo);
  // Eager init to prepare map as soon as UI builds
  vm.init();
  return vm;
});
