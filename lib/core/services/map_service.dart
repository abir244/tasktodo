
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  static CameraUpdate cameraTo(LatLng target, {double zoom = 15}) {
    return CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: zoom),
    );
  }
}

