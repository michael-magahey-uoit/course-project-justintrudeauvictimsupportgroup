import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
  });
}

final mapMarkers = [
  MapMarker(
      image: 'clawmachine_test.png',
      title: 'Claw Machine Location.',
      address: '2000 Simcoe St N, Oshawa L1G 0C5, Canada',
      location: LatLng(43.944, -78.896)),
      MapMarker(
      image: 'clawmachine_test.png',
      title: 'McCoy\'s Burgers.',
      address: '2069 Simcoe St N, Oshawa, L1G 0C7, Canada',
      location: LatLng(43.961, -78.891)),
];
