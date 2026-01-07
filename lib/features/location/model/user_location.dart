
class UserLocation {
  final double lat;
  final double lng;
  final String? address;

  const UserLocation({required this.lat, required this.lng, this.address});

  @override
  String toString() => 'UserLocation(lat: $lat, lng: $lng, address: $address)';
}
